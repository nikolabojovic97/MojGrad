using Microsoft.EntityFrameworkCore;
using miniApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace miniApp.Data
{
    public class ApplicationDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite(@"DataSource=baza.db");
        }

        public DbSet<miniApp.Models.Book> Book { get; set; }
        public DbSet<User> Users { get; set; }
    }
        

}
