using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services.Interfaces
{
    public interface IPostReportService
    {
        Task<PostReport> CreateAsync(PostReport pr);
        Task<PostReport> RetrieveAsync(int id);
        Task<IEnumerable<PostReport>> RetrieveAllAsync();
        Task<IEnumerable<PostReport>> RetrieveByPostIDAsync(int id);
        Task<IEnumerable<PostReport>> RetrieveByUserAsync(string username);
        Task<bool> CheckIfExistsAsync(int id, string username);
        Task<bool?> DeleteAsync(int id);
        Task<double> CalculateValidity(string username);
    }
}
