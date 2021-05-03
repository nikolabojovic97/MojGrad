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
    public class CommentReportController : ControllerBase
    {
        private ICommentReportService commentReportService;

        public CommentReportController(ICommentReportService commentReportService)
        {
            this.commentReportService = commentReportService;
        }

        // GET: /api/CommentReport
        // GET: /api/CommentReport/?username=[username]
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(IEnumerable<CommentReport>))]
        public async Task<IEnumerable<CommentReport>> GetAllCommentReports(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return await commentReportService.RetrieveAllAsync();
            else
                return await commentReportService.RetrieveByUserAsync(username);
        }

        // GET: /api/CommentReport/{id}
        [HttpGet("{id}", Name = nameof(GetCommentReport))]
        [ProducesResponseType(200, Type = typeof(CommentReport))]
        [ProducesResponseType(404)]
        public async Task<IActionResult> GetCommentReport(int id)
        {
            CommentReport cr = await commentReportService.RetrieveAsync(id);
            if (cr == null)
                return NotFound();
            return Ok(cr);
        }

        // GET: /api/CommentReport/allCommentReports?commentID=[commentID]
        [HttpGet("allCommentReports")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<CommentReport>))]
        public async Task<IEnumerable<CommentReport>> GetAllReportsOfComment(int commentID)
        {
            return await commentReportService.RetrieveByCommentIDAsync(commentID);
        }

        // POST: /api/CommentReport
        // BODY: CommentReport (JSON, XML)
        [HttpPost]
        [ProducesResponseType(201, Type = typeof(CommentReport))]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        public async Task<IActionResult> Create([FromBody] CommentReport cr)
        {
            if (cr == null)
                return BadRequest();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            
            bool exists = await commentReportService.CheckIfExistsAsync(cr.CommentId, cr.UserName);
            if (exists)
                return Ok();

            CommentReport added = await commentReportService.CreateAsync(cr);

            return CreatedAtRoute(
                    routeName: nameof(GetCommentReport),
                    routeValues: new { id = added.Id },
                    value: added
                );
        }

        // DELETE: api/CommentReport?id=[id]
        [HttpDelete]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> Delete(int id)
        {
            var existing = await commentReportService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await commentReportService.DeleteAsync(id);
            if (deleted.HasValue && deleted.Value)
                return new NoContentResult();
            else
                return BadRequest($"Comment report {id} was found but failed to delete.");
        }
    }
}