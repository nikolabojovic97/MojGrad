using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Data;
using WebApi.Models;

namespace WebApi.Services
{
    public class UserService : IUserService
    {
        private ApplicationDbContext _db;
        private IConfiguration _configuration;

        public UserService(ApplicationDbContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        public void AddNewUser(User user)
        {
            _db.User.Add(user);
            _db.SaveChanges();
        }

        public IEnumerable<User> GetAllUsers()
        {
            return _db.User;
        }

        public User GetUser(string email, string password)
        {
            return _db.User.Where(x => x.Email == email && x.Password == password).FirstOrDefault();
        }

        public User GetUserByID(string email)
        {
            return _db.User.Where(x => x.Email == email).FirstOrDefault();
        }
    }
}
