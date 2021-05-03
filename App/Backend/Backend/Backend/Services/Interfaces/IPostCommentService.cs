using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services.Interfaces
{
    public interface IPostCommentService
    {
        Task<PostComment> CreateAsync(PostComment pc);
        Task<PostComment> RetrieveAsync(int id);
        Task<IEnumerable<PostComment>> RetrieveByUserAsync(string username);
        Task<IEnumerable<PostComment>> RetrieveByPostIdAsync(int postId);
        Task<bool?> DeleteAsync(int id);
        Task<bool> DeleteAllReportsOfComment(int commentId);
        Task<bool> ApproveAllReportsOfComment(int commentId);
    }
}
