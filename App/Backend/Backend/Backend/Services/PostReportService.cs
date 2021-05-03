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
    public class PostReportService : IPostReportService
    {
        private ApplicationDbContext db;
        private readonly IConfiguration configuration;

        public PostReportService(ApplicationDbContext db, IConfiguration configuration)
        {
            this.db = db;
            this.configuration = configuration;
        }

        public async Task<PostReport> CreateAsync(PostReport pr)
        {
            await db.PostReports.AddAsync(pr);
            await db.SaveChangesAsync();
            return pr;
        }

        public async Task<bool?> DeleteAsync(int id)
        {
            PostReport pr = db.PostReports.Find(id);
            pr.ReportStatus = ReportStatus.Declined; 
            db.PostReports.Update(pr);
            int updated = await db.SaveChangesAsync();

            if (updated == 1)
                return true;
            else 
                return null;
        }

        private async Task<String> getUsernameByPostID(int postID)
        {
            return await Task.Run(() =>
            {
                string username = db.Posts.Where(x => x.Id == postID).Select(x => x.UserName).FirstOrDefault();
                return username;
            });
        }

        public Task<IEnumerable<PostReport>> RetrieveAllAsync()
        {
            return Task.Run(async () =>
            {
                IEnumerable<PostReport> postReports = from post in db.Posts
                                                      join report in db.PostReports
                                                      on post.Id equals report.PostId
                                                      where report.ReportStatus == ReportStatus.Pending
                                                      select report;


                foreach (var report in postReports)
                {
                    report.ReportsNumber = db.PostReports.Where(x => x.PostId == report.PostId).Count();
                    report.ReportedUserName = await getUsernameByPostID(report.PostId);
                    report.ReportValidity = await CalculateValidity(report.UserName);
                }
                return postReports;
            });
        }

        public Task<PostReport> RetrieveAsync(int id)
        {
            return Task.Run(() =>
            {
                PostReport pr;
                pr = db.PostReports.AsNoTracking<PostReport>().Where(x => x.Id == id).FirstOrDefault();
                return pr;
            });
        }

        public Task<IEnumerable<PostReport>> RetrieveByPostIDAsync(int id)
        {
            return Task.Run(() =>
            {
                IEnumerable<PostReport> reports;
                reports = db.PostReports.Where(x => x.PostId == id);
                return reports;
            });
        }

        public Task<IEnumerable<PostReport>> RetrieveByUserAsync(string username)
        {
            return Task.Run(() =>
            {
                IEnumerable<PostReport> reports;
                reports = db.PostReports.Where(x => x.UserName.Equals(username));
                return reports;
            });
        }

        public async Task<bool> CheckIfExistsAsync(int postid, string username) 
        {
            return await Task.Run(() =>
            {
                PostReport postReport;
                postReport = db.PostReports.AsNoTracking().Where(pr => pr.PostId == postid && pr.UserName == username).FirstOrDefault();
                if (postReport != null)
                    return true;
                else 
                    return false;
            });
        }

        public async Task<double> CalculateValidity(string username)
        {
            return await Task.Run(() =>
            {
                var numberOfReports = db.PostReports.Where(x => x.UserName == username).Count();
                var approved = db.PostReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Approved).Count();
                var pending = db.PostReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Pending).Count();

                double tmp = numberOfReports - pending;
                double validity = 0;

                if (tmp != 0)
                    validity = approved / tmp;

                return validity * 100;
            });
        }
    }
}
