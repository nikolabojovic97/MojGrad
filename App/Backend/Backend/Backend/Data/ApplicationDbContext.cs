using Backend.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Post> Posts { get; set; }
        public DbSet<PostLike> PostLikes { get; set; } 
        public DbSet<PostComment> PostComments { get; set; }
        public DbSet<PostReport> PostReports { get; set; }
        public DbSet<CommentReport> CommentReports { get; set; }
        public DbSet<PostImage> PostImages { get; set; }
        public DbSet<PostSolution> PostSolutions { get; set; }
        public DbSet<PostProblemType> PostProblemTypes { get; set; }
    }
}
