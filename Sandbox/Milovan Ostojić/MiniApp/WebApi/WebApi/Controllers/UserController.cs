using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApi.Models;
using WebApi.Services;

namespace WebApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpPost]
        public void AddNewUser(User user)
        {
            _userService.AddNewUser(user);
        }

        [HttpGet]
        public IActionResult GetAllUsers()
        {
            var res = _userService.GetAllUsers();

            if (res == null)
                return NotFound();

            return Ok(res);
        }

        [HttpGet("{email}")]
        public IActionResult GetUserByID(string email)
        {
            var res = _userService.GetUserByID(email);

            if (res == null)
                return NotFound();

            return Ok(res);
        }

        [HttpGet("{email}/{password}")]
        public IActionResult GetUser(String email, String password)
        {
            var res = _userService.GetUser(email, password);

            if (res == null)
                return NotFound();

            return Ok(res);
        }
    }
}