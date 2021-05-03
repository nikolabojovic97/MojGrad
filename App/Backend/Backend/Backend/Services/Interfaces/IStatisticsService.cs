using Backend.Models;
using Backend.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services.Interfaces
{
    public interface IStatisticsService
    {
        Task AddPostProblemTypeAsync(PostProblemType type);
        Task<Statistics> GetStatistics();
    }
}
