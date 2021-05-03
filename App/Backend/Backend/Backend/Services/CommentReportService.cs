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
    public class CommentReportService : ICommentReportService
    {
        private ApplicationDbContext db;
        private readonly IConfiguration configuration;

        public CommentReportService(ApplicationDbContext db, IConfiguration configuration)
        {
            this.db = db;
            this.configuration = configuration;
        }

        public async Task<CommentReport> CreateAsync(CommentReport cr)
        {
            await db.CommentReports.AddAsync(cr);
            await db.SaveChangesAsync();
            return cr;
        }

        public async Task<bool?> DeleteAsync(int id)
        {
            CommentReport cr = db.CommentReports.Find(id);
            cr.ReportStatus = ReportStatus.Declined;
            db.CommentReports.Update(cr);
            int updated = await db.SaveChangesAsync();

            if (updated == 1)
                return true;
            else
                return null;
        }


        private async Task<String> getUsernameByCommentID(int commentID)
        {
            return await Task.Run(() =>
            {
                string username = db.PostComments.Where(x => x.Id == commentID).Select(x => x.UserName).FirstOrDefault();
                return username;
            });
        }

        public Task<IEnumerable<CommentReport>> RetrieveAllAsync()
        {
            return Task.Run(async () =>
            {
                IEnumerable<CommentReport> commentReports = from comment in db.PostComments
                                                            join report in db.CommentReports
                                                            on comment.Id equals report.CommentId
                                                            where report.ReportStatus == ReportStatus.Pending
                                                            select report;

                foreach (var report in commentReports)
                {
                    report.ReportsNumber = db.CommentReports.Where(x => x.CommentId == report.CommentId).Count();
                    report.PostId = db.PostComments.Find(report.CommentId).PostId;
                    report.ReportedUserName = await getUsernameByCommentID(report.CommentId);
                    report.ReportValidity = await CalculateValidity(report.UserName);
                }
                return commentReports;
            });
        }

        public Task<CommentReport> RetrieveAsync(int id)
        {
            return Task.Run(async () =>
            {
                CommentReport cr;
                cr = db.CommentReports.AsNoTracking<CommentReport>().Where(x => x.Id == id).FirstOrDefault();
                cr.ReportsNumber = db.CommentReports.Where(x => x.CommentId == cr.CommentId).Count();
                cr.PostId = db.PostComments.Find(cr.CommentId).PostId;
                cr.ReportedUserName = await getUsernameByCommentID(cr.CommentId);
                return cr;
            });
        }

        public Task<IEnumerable<CommentReport>> RetrieveByCommentIDAsync(int id)
        {
            return Task.Run(() =>
            {
                IEnumerable<CommentReport> reports;
                reports = db.CommentReports.Where(x => x.CommentId == id);
                return reports;
            });
        }

        public Task<IEnumerable<CommentReport>> RetrieveByUserAsync(string username)
        {
            return Task.Run(() =>
            {
                IEnumerable<CommentReport> reports;
                reports = db.CommentReports.Where(x => x.UserName.Equals(username));
                return reports;
            });
        }

        public async Task<bool> CheckIfExistsAsync(int commentId, string username)
        {
            return await Task.Run(() =>
            {
                CommentReport commentReport;
                commentReport = db.CommentReports.AsNoTracking().Where(cr => cr.CommentId == commentId && cr.UserName == username).FirstOrDefault();
                if (commentReport != null)
                    return true;
                else
                    return false;
            });
        }

        public async Task<double> CalculateValidity(string username)
        {
            return await Task.Run(() =>
            {
                var numberOfReports = db.CommentReports.Where(x => x.UserName == username).Count();
                var approved = db.CommentReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Approved).Count();
                var pending = db.CommentReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Pending).Count();

                double tmp = numberOfReports - pending;
                double validity = 0;

                if (tmp != 0)
                 validity = approved / tmp;

                return validity * 100;
            });
        }
    }
}
