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
    public class PostCommentService : IPostCommentService
    {
        private ApplicationDbContext db;
        private readonly IConfiguration configuration;

        public PostCommentService(ApplicationDbContext db, IConfiguration configuration)
        {
            this.db = db;
            this.configuration = configuration;
        }
        public async Task<PostComment> CreateAsync(PostComment pc)
        {
            await db.PostComments.AddAsync(pc);
            await db.SaveChangesAsync();
            return pc;
        }

        public async Task<bool?> DeleteAsync(int id)
        {
            PostComment pc = db.PostComments.Find(id);
            db.PostComments.Remove(pc);

            int deleted = await db.SaveChangesAsync();

            if (deleted != 0)
                return true;
            else return null;
        }

        public Task<PostComment> RetrieveAsync(int id)
        {
            return Task.Run(() =>
            {
                PostComment pc;
                pc = db.PostComments.AsNoTracking<PostComment>().Where(x => x.Id == id).FirstOrDefault();
                pc.UserImgUrl = db.Users.Find(pc.UserName).ImgUrl;
                pc.ReportsNumber = db.CommentReports.Where(x => x.CommentId == pc.Id).Count();
                return pc;
            });
        }

        public Task<IEnumerable<PostComment>> RetrieveByPostIdAsync(int postId)
        {
            return Task.Run(() =>
            {
                IEnumerable<PostComment> postComments;
                postComments = db.PostComments.Where(p => p.PostId.Equals(postId));
                foreach (var post in postComments)
                    post.UserImgUrl = db.Users.Find(post.UserName).ImgUrl;
                return postComments;
            });
        }


        public Task<IEnumerable<PostComment>> RetrieveByUserAsync(string username)
        {
            return Task.Run(() => {
                IEnumerable<PostComment> postComments;
                postComments = db.PostComments.Where(pc => pc.UserName.Equals(username));
                return postComments;
            });
        }

        public async Task<bool> ApproveAllReportsOfComment(int commentId)
        {
            IEnumerable<CommentReport> commentReports = db.CommentReports.Where(cr => cr.CommentId == commentId);
            if (commentReports != null)
            {
                foreach (var report in commentReports)
                {
                    report.ReportStatus = ReportStatus.Approved;
                    db.CommentReports.Update(report);
                }
            }

            int res = await db.SaveChangesAsync();

            if (res != 0)
                return true;
            else
                return false;
        }

        public async Task<bool> DeleteAllReportsOfComment(int commentId)
        {
            IEnumerable<CommentReport> commentReports = db.CommentReports.Where(cr => cr.CommentId == commentId);
            if(commentReports != null)
            {
                foreach (var report in commentReports)
                {
                    report.ReportStatus = ReportStatus.Declined;
                    db.CommentReports.Update(report);
                }
            }

            int res = await db.SaveChangesAsync();

            if (res != 0)
                return true;
            else
                return false;
        }
    }
}
