using Backend.Data;
using Backend.Models;
using Backend.Models.Enums;
using Backend.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services
{
    public class StatisticsService : IStatisticsService
    {
        private ApplicationDbContext db;
        private readonly IConfiguration configuration;

        public StatisticsService(ApplicationDbContext db, IConfiguration configuration)
        {
            this.db = db;
            this.configuration = configuration;
        }

        public Task AddPostProblemTypeAsync(PostProblemType type)
        {
            return Task.Run(async () =>
            {
                await db.PostProblemTypes.AddAsync(type);
                await db.SaveChangesAsync();
            });
        }

        public Task<List<double>> CalculateProblemTypeStats()
        {
            return Task.Run(() =>
            {
                var problemTypes = db.PostProblemTypes.ToList();
                int numberOfRows = problemTypes.Count;
                int numberOfTypes = Enum.GetNames(typeof(ProblemType)).Length;
                List<double> countTypes = new List<double>();

                for (int i = 0; i < numberOfTypes; i++)
                    countTypes.Add(0);

                foreach (var item in problemTypes)
                    countTypes[(int)item.ProblemType] += 1;

                for(int i = 0; i < countTypes.Count; i++)
                    countTypes[i] /= numberOfRows;

                return countTypes;
            });
        }

        public Task<Statistics> GetStatistics()
        {
            return Task.Run(async () =>
            {
                Statistics stats = new Statistics
                {
                    UserNumber = await db.Users.CountAsync(),
                    PostNumber = await db.Posts.CountAsync(),
                    SolutionNumber = await db.PostSolutions.CountAsync(),
                    ReactionNumber = await db.PostLikes.CountAsync(),
                    CommentNumber = await db.PostComments.CountAsync(),
                    ReportNumber = await db.PostReports.CountAsync() + await db.CommentReports.CountAsync()
                };
                
                DateTime today = DateTime.Now;
                DateTime pastDate = today.AddDays(-10);

                List<double> dailyPosts = new List<double>();
                List<double> dailyLikes = new List<double>();

                stats.LatestPostNumber = await db.Posts.Where(x => x.DateCreated >= pastDate).CountAsync();
                stats.LatestReactionNumber = await db.PostLikes.Where(x => x.Time >= pastDate).CountAsync();
                stats.LatestCommentNumber = await db.PostComments.Where(x => x.DateCreated >= pastDate).CountAsync();
                stats.LatestReportNumber = await db.PostReports.Where(x => x.DateReported >= pastDate).CountAsync() + await db.CommentReports.Where(x => x.DateReported >= pastDate).CountAsync();


                while (pastDate <= today)
                {
                    var posts = await db.Posts.Where(x => x.DateCreated.Date == pastDate.Date).CountAsync();
                    dailyPosts.Add(posts);

                    var likes = await db.PostLikes.Where(x => x.Time.Date == pastDate.Date).CountAsync();
                    dailyLikes.Add(likes);

                    pastDate = pastDate.AddDays(1);
                }

                stats.DailyPosts = dailyPosts;
                stats.DailyLikes = dailyLikes;

                stats.ProblemTypes = await CalculateProblemTypeStats();

                return stats;
            });
        }
    }
}
