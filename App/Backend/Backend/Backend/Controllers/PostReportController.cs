using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class PostReportController : ControllerBase
    {
        private IPostReportService postReportService;

        public PostReportController(IPostReportService postReportService)
        {
            this.postReportService = postReportService;
        }

        // GET: /api/PostReport
        // GET: /api/PostReport/?username=[username]
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(IEnumerable<PostReport>))]
        public async Task<IEnumerable<PostReport>> GetAllPostReports(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return await postReportService.RetrieveAllAsync();
            else
                return await postReportService.RetrieveByUserAsync(username);

        }

        // GET: /api/PostReport/{id}
        [HttpGet("{id}", Name = nameof(GetPostReport))]
        [ProducesResponseType(200, Type = typeof(PostReport))]
        [ProducesResponseType(404)]
        public async Task<IActionResult> GetPostReport(int id)
        {
            PostReport pr = await postReportService.RetrieveAsync(id);
            if (pr == null)
                return NotFound();
            return Ok(pr);
        }

        // GET: /api/PostReport/allPostReports?postID=[postID]
        [HttpGet("allPostReports")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<PostReport>))]
        public async Task<IEnumerable<PostReport>> GetAllReportsOfPost(int postID)
        {
            return await postReportService.RetrieveByPostIDAsync(postID);
        }


        // POST: /api/PostReport
        // BODY: PostReport (JSON, XML)
        [HttpPost]
        [ProducesResponseType(201, Type = typeof(PostReport))]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        public async Task<IActionResult> Create([FromBody] PostReport pr)
        {
            if (pr == null)
                return BadRequest();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            bool exists = await postReportService.CheckIfExistsAsync(pr.PostId, pr.UserName);
            if (exists)
                return Ok();


            PostReport added = await postReportService.CreateAsync(pr);

            return CreatedAtRoute(
                    routeName: nameof(GetPostReport),
                    routeValues: new { id = added.Id },
                    value: added
                );
        }

        // DELETE: api/PostReport?id=[id]
        [HttpDelete]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> Delete(int id)
        {
            var existing = await postReportService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await postReportService.DeleteAsync(id);
            if (deleted.HasValue && deleted.Value)
                return new NoContentResult();
            else
                return BadRequest($"Post report {id} was found but failed to delete.");
        }
    }
}