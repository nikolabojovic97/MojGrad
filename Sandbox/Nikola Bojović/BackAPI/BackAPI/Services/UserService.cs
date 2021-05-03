using BackAPI.Data;
using BackAPI.Models;
using BackAPI.Utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace BackAPI.Services
{
    public interface IUserService
    {
        User GetUser(string username);
        User Register(User user);
        User Authenticate(string username, string password);
        User Update(User user);
        void Delete(User user);
    }

    public class UserService : IUserService
    {
        private ApplicationDbContext _context { get; }
        public IConfiguration Configuration { get; }


        public UserService(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            Configuration = configuration;
        }

        public User GetUser(string username)
        {
            return _context.Users.Where(x => x.Username == username).FirstOrDefault();
        }

        public User Register(User user)
        {
            if(user != null)
            {
                user.Password = Hash.ComputeSha256Hash(user.Password).ToUpper();
                _context.Users.Add(user);
                _context.SaveChangesAsync();
            }
            return user;
        }

        public User Authenticate(string username, string password)
        {
            var user = _context.Users.Where(x => x.Username == username && x.Password == password).FirstOrDefault();

            if (user == null)
                return null;

            // authentication successful so generate jwt token
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(Configuration.GetValue<string>("Secret"));
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, user.Id.ToString())
                }),
                Expires = DateTime.UtcNow.AddDays(7),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            user.Token = tokenHandler.WriteToken(token);
            user.Password = null;

            return user;
        }

        public User Update(User user)
        {
             _context.Users.Update(user);
            _context.SaveChanges();
            user.Password = null;
            return user;
        }

        public void Delete(User user)
        {
            if (user != null)
                _context.Users.Remove(user);
        }
    }
}
