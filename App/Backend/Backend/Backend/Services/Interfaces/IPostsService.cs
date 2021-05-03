using Backend.Models;
using Backend.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services.Interfaces
{
    public interface IPostsService
    {
        Task<Post> CreateAsync(Post p);
        Task<Post> UpdateAsync(Post p);
        Task<Post> RetrieveAsync(int id);
        Task<IEnumerable<Post>> RetrieveByUserAsync(string username);
        Task<IEnumerable<Post>> RetrieveAllAsync(string userName = "");
        Task<IEnumerable<Post>> GetSortedAsync(SortType type, int number);
        Task<IEnumerable<Post>> GetSearchedAsync(string value, string username);
        Task<bool?> DeleteAsync(int id);
        Task<bool?> DeclineReports(int id);
        Task<bool> ApproveAllReportsOfPost(int postId);
        Task<IEnumerable<Post>> RetrieveByPopularityAsync(string location = "");
        Task<IEnumerable<Post>> RetrieveByDateCreatedAsync(string location = "");
        Task<bool> SaveImageAsync(string imagePath, byte[] imageData);
        Task<bool> AddLikeOnPostAsync(PostLike pl);
        Task<bool> CheckLikeStatusAsync(int postId, string userName);
        public Task<bool?> DeleteLikeOnPostAsync(PostLike pl);
        public Task<bool> CascadeDeleteByPostId(int postId);
        public Task<PostImage> AddPostImage(PostImage postImage);
        public Task<bool> DeleteAllReportsOfPost(int postId);
        public Task<bool> DeleteAllPostsByUser(string username);
        public Task<Post> GetPostProblemBySolutionId(string userName, int solutionId);
        public Task<PostSolution> CreatePostSolutionAsync(PostSolution ps);
        Task<List<Post>> RetrieveByCityAsync(string city);
    }
}
