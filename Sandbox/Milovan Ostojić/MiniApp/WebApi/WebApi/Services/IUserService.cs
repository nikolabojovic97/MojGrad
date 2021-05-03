using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Models;

namespace WebApi.Services
{
    public interface IUserService
    {
        public void AddNewUser(User user);
        public User GetUserByID(string email);
        public IEnumerable<User> GetAllUsers();
        public User GetUser(String email, String password);
    }
}
