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
    public class StatisticsController : ControllerBase
    {
        private IStatisticsService statisticsService;

        public StatisticsController(IStatisticsService statisticsService)
        {
            this.statisticsService = statisticsService;
        }

        // GET: /api/Statistics
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(Statistics))]
        public async Task<Statistics> GetStatistics()
        {
            return await statisticsService.GetStatistics();
        }


        //POST: /api/Statistics
        [HttpPost]
        [ProducesResponseType(204, Type = typeof(Statistics))]
        [ProducesResponseType(400, Type = typeof(Statistics))]
        public async Task<IActionResult> AddPostProblemType(PostProblemType type)
        {
            await statisticsService.AddPostProblemTypeAsync(type);
            return NoContent();
        }
    }
}