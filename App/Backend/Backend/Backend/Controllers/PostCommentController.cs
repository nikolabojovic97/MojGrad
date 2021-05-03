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
    public class PostCommentController : ControllerBase
    {
        private IPostCommentService postCommentService;

        public PostCommentController(IPostCommentService postCommentService)
        {
            this.postCommentService = postCommentService;
        }

        [HttpGet]
        [ProducesResponseType(200, Type = typeof(IEnumerable<PostComment>))]
        public async Task<IEnumerable<PostComment>> GetAllPostComments(String username)
        {
            return await postCommentService.RetrieveByUserAsync(username);
        }

        [HttpGet("postId/{postId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<PostComment>))]
        public async Task<IEnumerable<PostComment>> GetAllPostCommentsByPostId(int postId)
        {
            return await postCommentService.RetrieveByPostIdAsync(postId);
        }


        [HttpGet("{id}", Name =nameof(GetPostComment))]
        [ProducesResponseType(200, Type = typeof(PostComment))]
        [ProducesResponseType(404)]
        public async Task<IActionResult> GetPostComment(int id)
        {
            PostComment pc = await postCommentService.RetrieveAsync(id);
            if (pc == null)
                return NotFound();
            return Ok(pc);
        }

        [HttpPost]
        [ProducesResponseType(201, Type = typeof(PostComment))]
        [ProducesResponseType(400)]
        public async Task<IActionResult> Create([FromBody] PostComment pc)
        {
            if (pc == null)
                return BadRequest();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            PostComment added = await postCommentService.CreateAsync(pc);

            return CreatedAtRoute(
                routeName: nameof(GetPostComment),
                routeValues: new { id = added.Id },
                value: added
                );
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var existing = await postCommentService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await postCommentService.DeleteAsync(id);
            if (deleted.HasValue && deleted.Value)
                return new NoContentResult();
            else
                return BadRequest($"PostComment {id} was found but failed to delete.");
        }

        // DELETE: api/PostComment/deleteAndApproveReports/?id=[id]
        [HttpDelete("deleteAndApproveReports")]
        public async Task<IActionResult> DeleteAndApproveReports(int id)
        {
            var existing = await postCommentService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await postCommentService.DeleteAsync(id);
            if (deleted.HasValue && deleted.Value)
            {
                await postCommentService.ApproveAllReportsOfComment(id);
                return new NoContentResult();
            }
            else
                return BadRequest($"PostComment {id} was found but failed to delete.");
        }

        // DELETE: api/PostComment/deleteAllReports/?id=[id]
        [HttpDelete("deleteAllReports")]
        public async Task<IActionResult> DeleteAllReportsOfComment(int id)
        {
            var existing = await postCommentService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await postCommentService.DeleteAllReportsOfComment(id);
            if (deleted.HasValue && deleted.Value)
                return new NoContentResult();
            else
                return BadRequest("Reports are not deleted.");
        }
    }
}