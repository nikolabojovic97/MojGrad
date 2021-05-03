using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services.Interfaces
{
    public interface ICommentReportService
    {
        Task<CommentReport> CreateAsync(CommentReport cr);
        Task<CommentReport> RetrieveAsync(int id);
        Task<IEnumerable<CommentReport>> RetrieveAllAsync();
        Task<IEnumerable<CommentReport>> RetrieveByCommentIDAsync(int id);
        Task<IEnumerable<CommentReport>> RetrieveByUserAsync(string username);
        Task<bool> CheckIfExistsAsync(int commentId, string username);
        Task<bool?> DeleteAsync(int id);
        Task<double> CalculateValidity(string username);
    }
}
