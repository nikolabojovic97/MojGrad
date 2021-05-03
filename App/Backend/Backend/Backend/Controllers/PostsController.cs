using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Models.Enums;
using Backend.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class PostsController : ControllerBase
    {
        private IPostsService postsService;

        public PostsController(IPostsService postsService)
        {
            this.postsService = postsService;
        }

        // GET: /api/Posts
        // GET: /api/Posts/?username=[username]
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Post>))]
        public async Task<IEnumerable<Post>> GetAllPosts(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return await postsService.RetrieveAllAsync();
            else
                return await postsService.RetrieveByUserAsync(username);
        }

        // GET: /api/Posts/forUser?userName=[userName]
        [HttpGet("forUser")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Post>))]
        public async Task<IEnumerable<Post>> GetAllPostsForUser(string userName)
        {
            if (string.IsNullOrWhiteSpace(userName))
                return await postsService.RetrieveAllAsync();
            else
                return await postsService.RetrieveAllAsync(userName);
        }

        //GET /api/Posts/sort/dates_asc|dates_desc
        //GET /api/Posts/sort/leaves_asc|leaves_desc
        //GET /api/Posts/sort/comments_asc|comments_desc
        [HttpGet("sort/{type}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Post>))]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        public async Task<IEnumerable<Post>> Sort(SortType type, int number)
        {
            return await postsService.GetSortedAsync(type, number);
        }

        //GET /api/Posts/search/value
        [HttpGet("search/{value}/{username}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Post>))]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        public async Task<IEnumerable<Post>> Search(string value, string username)
        {
            return await postsService.GetSearchedAsync(value.ToLower(), username);
        }

        // GET: /api/Posts/{id}
        [HttpGet("{id}", Name = nameof(GetPost))]
        [ProducesResponseType(200, Type = typeof(Post))]
        [ProducesResponseType(204)]
        public async Task<IActionResult> GetPost(int id)
        {
            Post p = await postsService.RetrieveAsync(id);
            if (p == null)
                return NoContent();
            return Ok(p);
        }

        // GET: /api/Posts/city/Kragujevac
        [HttpGet("city/{city}", Name = nameof(GetPostsByCity))]
        [ProducesResponseType(200, Type = typeof(Post))]
        [ProducesResponseType(204)]
        [ProducesResponseType(401)]
        public async Task<IActionResult> GetPostsByCity(string city)
        {
            List<Post> posts = await postsService.RetrieveByCityAsync(city);
            if (posts == null)
                return NoContent();
            return Ok(posts);
        }

        // POST: /api/Posts
        // BODY: Post (JSON, XML)
        [HttpPost]
        [ProducesResponseType(201, Type = typeof(Post))]
        [ProducesResponseType(400)]
        public async Task<IActionResult> Create([FromBody] Post p)
        {
            if (p == null)
                return BadRequest();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            Post added = await postsService.CreateAsync(p);

            return CreatedAtRoute(
                    routeName: nameof(GetPost),
                    routeValues: new { id = added.Id },
                    value: added
                );
        }

        // PUT: /api/Posts/[id]
        // BODY: Post (JSON, XML)
        [HttpPut("{id}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> Update(int id, [FromBody] Post p)
        {
            if (p == null)
                return BadRequest();

            if (p.Id != id)
                return BadRequest();

            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existing = await postsService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            await postsService.UpdateAsync(p);

            return new NoContentResult();
        }

        // DELETE: api/Posts/[id]
        [HttpDelete("{id}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> Delete(int id)
        {
            var existing = await postsService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await postsService.DeleteAsync(id);
            if (deleted.HasValue && deleted.Value)
            {
                await postsService.CascadeDeleteByPostId(id);
                return new NoContentResult();
            }
            else
                return BadRequest($"Post {id} was found but failed to delete.");
        }

        // DELETE: api/Posts/deleteAndApproveReports?id=[id]
        [HttpDelete("deleteAndApproveReports")]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> DeletePostAndApproveReports(int id)
        {
            var existing = await postsService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await postsService.DeleteAsync(id);
            if (deleted.HasValue && deleted.Value)
            {
                await postsService.CascadeDeleteByPostId(id);
                await postsService.ApproveAllReportsOfPost(id);
                return new NoContentResult();
            }
            else
                return BadRequest($"Post {id} was found but failed to delete.");
        }

        [HttpGet("{userName}/{solutionId}")]
        public async Task<Post> GetPostProblemBySolutionId(string userName, int solutionId)
        {
            Post problem = await postsService.GetPostProblemBySolutionId(userName, solutionId);
            return problem;
        }

        [HttpPost("solution")]
        public async Task<IActionResult> AddPostSolution([FromBody] PostSolution postSolution)
        {
            if (postSolution == null)
                return BadRequest();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            PostSolution added = await postsService.CreatePostSolutionAsync(postSolution);

            return Ok();
        }

        [HttpPost("image")]
        public async Task<IActionResult> SaveImage([FromBody]UploadPostImage obj)
        {
            if(obj.ImageData != null)
            {
                string imagePath;
                int i = 0;
                PostImage postImage = new PostImage();

                foreach(var data in obj.ImageData) {
                    var image = Convert.FromBase64String(data);
                    imagePath = "wwwroot/src/Posts/" + i.ToString() + obj.ImageName;
                    await postsService.SaveImageAsync(imagePath, image);
                    postImage.ImageUrl = i.ToString() + obj.ImageName;
                    postImage.PostId = obj.PostId;
                    await postsService.AddPostImage(postImage);
                    i++;
                }
                return Ok();
            }
            return BadRequest(new { message = "Something is wrong with image!" });
        }

        [HttpPost("like")]
        public async Task<IActionResult> AddLikeOnPost([FromBody]PostLike postLike)
        {
            if (postLike == null)
                return BadRequest();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
           
            bool added = await postsService.AddLikeOnPostAsync(postLike);
            if (added)
                return Ok();
            else
                return BadRequest(new { message = "Like is not added!" });  
        }

        [HttpPost("deleteLike")]
        public async Task<IActionResult> DeleteLikeOnPost([FromBody]PostLike postLike)
        {
            var existing = await postsService.CheckLikeStatusAsync(postLike.PostId,postLike.UserName);
            if (existing == false)
                return NotFound();

            bool? deleted = await postsService.DeleteLikeOnPostAsync(postLike);
            if (deleted.HasValue && deleted.Value)
                return Ok();
            else
                return BadRequest($"Like {postLike.Id} was found but failed to delete.");
        }

        [HttpPost("likeStatus")]
        public async Task<IActionResult> CheckLikeStatus([FromBody]PostLike postLike)
        {
            if (postLike == null)
                return BadRequest();
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            bool isLiked = await postsService.CheckLikeStatusAsync(postLike.Id, postLike.UserName);

            if (isLiked)
                return Ok();
            else return NotFound();

        }

        // DELETE: api/Posts/deleteAllReports/?id=[id]
        [HttpDelete("deleteAllReports")]
        public async Task<IActionResult> DeleteAllReportsOfPost(int id)
        {
            var existing = await postsService.RetrieveAsync(id);
            if (existing == null)
                return NotFound();

            bool? deleted = await postsService.DeleteAllReportsOfPost(id);
            if (deleted.HasValue && deleted.Value)
                return new NoContentResult();
            else
                return BadRequest("Reports are not deleted.");
        }

        // DELETE: api/Posts/deleteAllPostsByUser/?username=[username]
        [HttpDelete("deleteAllPostsByUser")]
        public async Task<IActionResult> DeleteAllPostsByUser(string username)
        {
            bool deleted = await postsService.DeleteAllPostsByUser(username);
            if (deleted == true)
                return new NoContentResult();
            else
                return BadRequest($"Posts by user {username} failed to delete");
        }
    }
}