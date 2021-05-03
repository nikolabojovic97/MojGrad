using Backend.Data;
using Backend.Models;
using Backend.Models.Enums;
using Backend.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services
{
    public class PostService : IPostsService
    {
        private ApplicationDbContext db;
        private readonly IConfiguration configuration;

        public PostService(ApplicationDbContext db, IConfiguration configuration)
        {
            this.db = db;
            this.configuration = configuration;
        }

        public async Task<Post> CreateAsync(Post p)
        {
            await db.Posts.AddAsync(p);
            await db.SaveChangesAsync();
            return p;
        }

        public async Task<PostSolution> CreatePostSolutionAsync(PostSolution ps)
        {
            await db.PostSolutions.AddAsync(ps);
            await db.SaveChangesAsync();
            return ps;
        }

        public async Task<bool?> DeleteAsync(int id)
        {
            Post p = db.Posts.Find(id);
            db.Posts.Remove(p);
            var ppt = db.PostProblemTypes.Where(x => x.PostId == id).FirstOrDefault();

            if (ppt != null)
                db.PostProblemTypes.Remove(ppt);
            int deleted = await db.SaveChangesAsync();

            return true;
        }

        public async Task<bool?> DeclineReports(int id)
        {
            IEnumerable<PostReport> reports = db.PostReports.Where(x => x.PostId == id);

            foreach (var report in reports)
            {
                report.ReportStatus = ReportStatus.Approved;
                db.PostReports.Update(report);
            }

            int updated = await db.SaveChangesAsync();

            if (updated > 0)
                return true;

            return null;
        }

        public Task<IEnumerable<Post>> RetrieveAllAsync(string userName = "")
        {
            if(userName == "")
            {
                return Task.Run(async () =>
                {
                    PostSolution postSolution;
                    PostSolution isSolution;
                    IEnumerable<Post> posts = db.Posts;
                    foreach (var p in posts)
                    {
                        p.LeafNumber = await GetLeafNumberById(p.Id);
                        p.UserImageUrl = db.Users.Find(p.UserName).ImgUrl;
                        p.ImgUrl = db.PostImages.Where(pi => pi.PostId == p.Id).Select(x => x.ImageUrl);
                        postSolution = db.PostSolutions.AsNoTracking().Where(ps => ps.PostProblemId == p.Id).FirstOrDefault();
                        if(postSolution != null)
                        {
                            p.IsSolved = true;
                        }
                        else
                        {
                            p.IsSolved = false;
                            isSolution = db.PostSolutions.AsNoTracking().Where(ps => ps.PostSolutionId == p.Id).FirstOrDefault();
                            if (isSolution != null)
                                p.isSolution = true;
                            else p.isSolution = false;

                        }
                    }     
                    return posts.Where(x => x.IsSolved == false);
                });
            }
            else
            {
                return Task.Run(async () =>
                {
                    PostSolution postSolution;
                    PostSolution isSolution;
                    IEnumerable<Post> posts = db.Posts;
                    foreach (var p in posts)
                    {
                        p.CommentsNumber = await GetCommentNumberById(p.Id);
                        p.ReportsNumber = await GetReportsNumberById(p.Id);
                        p.LeafNumber = await GetLeafNumberById(p.Id);
                        p.IsLiked = await CheckLikeStatusAsync(p.Id, userName);
                        p.UserImageUrl = db.Users.Find(p.UserName).ImgUrl;
                        p.ImgUrl = db.PostImages.Where(pi => pi.PostId == p.Id).Select(x => x.ImageUrl);
                        postSolution = db.PostSolutions.AsNoTracking().Where(ps => ps.PostProblemId == p.Id).FirstOrDefault();
                        if (postSolution != null)
                        {
                            p.IsSolved = true;
                        }
                        else
                        {
                            p.IsSolved = false;
                            isSolution = db.PostSolutions.AsNoTracking().Where(ps => ps.PostSolutionId == p.Id).FirstOrDefault();
                            if (isSolution != null)
                                p.isSolution = true;
                            else p.isSolution = false;

                        }
                    }
                    return posts.Where(x => x.IsSolved == false);
                });
            }
        }

        public Task<Post> GetPostProblemBySolutionId(string userName, int solutionId)
        {
           return Task.Run(async () =>
           {
               Post postProblem = null;
       
               var problemId = db.PostSolutions.Where(ps => ps.PostSolutionId == solutionId).Select(x => x.PostProblemId).FirstOrDefault();
               postProblem = await RetrieveAsync(problemId);
               postProblem.IsLiked = await CheckLikeStatusAsync(postProblem.Id, userName);
               postProblem.isSolution = false;
               postProblem.IsSolved = true;
             
               return postProblem;
           });
        }

        public Task<Post> RetrieveAsync(int id)
        {
            return Task.Run(async () =>
            {
                Post p;
                p = db.Posts.AsNoTracking<Post>().Where(x => x.Id == id).FirstOrDefault();
                p.ImgUrl = db.PostImages.Where(pi => pi.PostId == p.Id).Select(x => x.ImageUrl);
                p.UserImageUrl = db.Users.Find(p.UserName).ImgUrl;
                p.LeafNumber = await GetLeafNumberById(p.Id);
                p.ReportsNumber = db.PostReports.Where(x => x.PostId == p.Id).Count();
                p.CommentsNumber = db.PostComments.Where(x => x.PostId == p.Id).Count();
                return p;
            });
        }

        public Task<IEnumerable<Post>> GetSortedAsync(SortType type, int number)
        {
            return Task.Run(async () =>
            {
                IEnumerable<Post> posts = await RetrieveAllAsync();

                if (type == SortType.dates_asc)
                    posts = posts.OrderBy(x => x.DateCreated);

                else if (type == SortType.dates_desc)
                    posts = posts.OrderByDescending(x => x.DateCreated);

                else if (type == SortType.leaves_asc)
                    posts = posts.OrderBy(x => x.LeafNumber);

                else if (type == SortType.leaves_desc)
                    posts = posts.OrderByDescending(x => x.LeafNumber);

                else if (type == SortType.comments_asc)
                    posts = posts.OrderBy(x => x.CommentsNumber);

                else if (type == SortType.comments_desc)
                    posts = posts.OrderByDescending(x => x.CommentsNumber);

                if (number != 0)
                    return posts.Take((int)number);
                return posts;
            });
        }

        public Task<IEnumerable<Post>> GetSearchedAsync(string value, string username)
        {
            return Task.Run(async () =>
            {
                IEnumerable<Post> posts = await RetrieveAllAsync(username);

                var result = posts.Where(
                    x => x.UserName.ToLower().Contains(value) || 
                    x.Description.ToLower().Contains(value) || 
                    x.Location.ToLower().Contains(value) ||
                    x.DateCreated.ToString().Contains(value));

                if (result != null)
                    return result;

                return posts;
            });
        }

        public async Task<Post> UpdateAsync(Post p)
        {
            db.Posts.Update(p);
            await db.SaveChangesAsync();
            return p;
        }

        public Task<IEnumerable<Post>> RetrieveByUserAsync(string username)
        {
            return Task.Run(async () =>
            {
                IEnumerable<Post> posts;
                PostSolution postSolution;
                PostSolution isSolution;

                posts = db.Posts.Where(p => p.UserName.Equals(username));

                foreach (var p in posts)
                {
                    p.LeafNumber = await GetLeafNumberById(p.Id);
                    p.UserImageUrl = db.Users.Find(p.UserName).ImgUrl;
                    p.ImgUrl = db.PostImages.Where(pi => pi.PostId == p.Id).Select(x => x.ImageUrl);
                    p.CommentsNumber = await GetCommentNumberById(p.Id);
                    p.ReportsNumber = await GetReportsNumberById(p.Id);
                    postSolution = db.PostSolutions.AsNoTracking().Where(ps => ps.PostProblemId == p.Id).FirstOrDefault();
                    if (postSolution != null)
                    {
                        p.IsSolved = true;
                    }
                    else
                    {
                        p.IsSolved = false;
                        isSolution = db.PostSolutions.AsNoTracking().Where(ps => ps.PostSolutionId == p.Id).FirstOrDefault();
                        if (isSolution != null)
                            p.isSolution = true;
                        else p.isSolution = false;

                    }
                }
                return posts;
           });
        }

        public Task<IEnumerable<Post>> RetrieveByPopularityAsync(string location)
        {

            if (location == "")
                return Task.Run(async () =>
                {
                    IEnumerable<Post> posts = await RetrieveAllAsync();
                    posts.OrderBy(p => p.LeafNumber).Take(5);
                    return posts;
                });
            else
            {
                return Task.Run(async () =>
                {
                    IEnumerable<Post> posts = await RetrieveAllAsync();
                    posts.Where(p => p.Location.Equals(location)).OrderBy(p => p.LeafNumber).Take(5);
                    return posts;
                });
            }
        }

        public Task<IEnumerable<Post>> RetrieveByDateCreatedAsync(string location)
        {
            if (location == "")
                return Task.Run<IEnumerable<Post>>(() => db.Posts.OrderByDescending(x => x.DateCreated));
            else
                return Task.Run<IEnumerable<Post>>(() => db.Posts.Where(x => x.Location == location).OrderByDescending(x => x.DateCreated));
        }

        public Task<List<Post>> RetrieveByCityAsync(string city)
        {
            return Task.Run(() =>
            {
                return db.Posts.Where(x => x.Location.ToUpper().Equals(city.ToUpper())).OrderByDescending(x => x.DateCreated).ToList();
            });
        }

        public async Task<bool> SaveImageAsync(string imagePath, byte[] imageData)
        {
            await File.WriteAllBytesAsync(imagePath, imageData);
            return true;
        }

        public async Task<PostImage> AddPostImage(PostImage postImage)
        {
            db.PostImages.Add(postImage);
            await db.SaveChangesAsync();
            return postImage;
        }

        private async Task<int> GetLeafNumberById(int postId)
        {
            return await Task.Run(() =>
            {
                int leafNumber = (from likes in db.PostLikes
                                  where likes.PostId == postId
                                  select likes).Count();
                return leafNumber;
            });
        }

        private async Task<int> GetCommentNumberById(int postId)
        {
            return await Task.Run(() =>
            {
                int commentNumber = db.PostComments.Where(x => x.PostId == postId).Count();
                return commentNumber;
            });
        }

        private async Task<int> GetReportsNumberById(int postId)
        {
            return await Task.Run(() =>
            {
                int reportsNumber = db.PostReports.Where(x => x.PostId == postId).Count();
                return reportsNumber;
            });
        }

        public async Task<bool> AddLikeOnPostAsync(PostLike pl)
        {
            await db.PostLikes.AddAsync(pl);
            await db.SaveChangesAsync();
            return true;
        }

        public async Task<bool> CheckLikeStatusAsync(int postId, string userName)
        {
            return await Task.Run(() =>
             {
                 PostLike pl = db.PostLikes.AsNoTracking().Where(x => x.PostId == postId && x.UserName == userName).FirstOrDefault();

                 if (pl != null)
                     return true;
                 else return false;
             });
        }

        public async Task<bool?> DeleteLikeOnPostAsync(PostLike postLike)
        {
            PostLike pl = db.PostLikes.AsNoTracking().Where(x => x.PostId == postLike.PostId && x.UserName == postLike.UserName).FirstOrDefault();
            db.PostLikes.Remove(pl);
            int deleted = await db.SaveChangesAsync();

            if (deleted == 1)
                return true;
            else return null;
        }

        public async Task<bool> CascadeDeleteByPostId(int postId)
        {
            IEnumerable<PostLike> postLikes = db.PostLikes.Where(pl => pl.PostId == postId);
            if (postLikes != null)
            {
                foreach (var like in postLikes)
                    db.PostLikes.Remove(like);
            }

            IEnumerable<PostImage> postImages = db.PostImages.Where(pi => pi.PostId == postId);
            {
                if(postImages != null)
                {
                    var path = "wwwroot/src/Posts/";
                    foreach(var image in postImages)
                    {
                        if(image.ImageUrl != "")
                        {
                            File.Delete(path + image.ImageUrl);
                            db.PostImages.Remove(image);
                        }
                    }
                }
            }

            IEnumerable<PostComment> postComments = db.PostComments.Where(pc => pc.PostId == postId);
            if (postComments != null)
            {
                foreach (var comment in postComments)
                {
                    db.PostComments.Remove(comment);
                }
            }

            // ako je post resenje nekog problema, samo skloniti iz tabele PostSolution naznaku o tome
            // ako je post pocetni problem nekog resenja, treba ukloniti taj post resenja
            PostSolution postSolution = db.PostSolutions.AsNoTracking().Where(ps => ps.PostSolutionId == postId).FirstOrDefault();
            if(postSolution != null)
            {
                db.PostSolutions.Remove(postSolution);
            }
            else
            {
                PostSolution postProblem = db.PostSolutions.AsNoTracking().Where(pp => pp.PostProblemId == postId).FirstOrDefault();

                if (postProblem != null)
                {
                    var postSolutionID = postProblem.PostSolutionId;
                    db.PostSolutions.Remove(postProblem);
                    await DeleteAsync(postSolutionID);
                    await CascadeDeleteByPostId(postSolutionID);
                }
            }

            int res = await db.SaveChangesAsync();

            if (res != 0)
                return true;
            else
                return false;
        }

        public async Task<bool> DeleteAllReportsOfPost(int postId) 
        {
            IEnumerable<PostReport> postReports = db.PostReports.Where(pr => pr.PostId == postId);
            if (postReports != null)
            {
                foreach (var report in postReports)
                {
                    report.ReportStatus = ReportStatus.Declined;
                    db.PostReports.Update(report);
                } 
            }

            int res = await db.SaveChangesAsync();

            if (res != 0)
                return true;
            else
                return false;
        }

        public async Task<bool> ApproveAllReportsOfPost(int postId)
        {
            IEnumerable<PostReport> postReports = db.PostReports.Where(pr => pr.PostId == postId);
            if (postReports != null)
            {
                foreach (var report in postReports)
                {
                    report.ReportStatus = ReportStatus.Approved;
                    db.PostReports.Update(report);
                }
            }

            int res = await db.SaveChangesAsync();

            if (res != 0)
                return true;
            else
                return false;
        }

        public async Task<bool> DeleteAllPostsByUser(string username)
        {
            var posts = db.Posts.Where(x => x.UserName == username);

            if(posts != null)
            {
                foreach (var post in posts)
                {
                    await CascadeDeleteByPostId(post.Id);

                    db.Posts.Remove(post);
                }
            }

            int res = await db.SaveChangesAsync();

            return true;
        }
    }
}
