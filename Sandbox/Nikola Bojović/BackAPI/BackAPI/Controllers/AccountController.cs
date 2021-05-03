using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BackAPI.Models;
using BackAPI.Services;
using BackAPI.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BackAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class AccountController : Controller
    {
        private IUserService _userService;

        public AccountController(IUserService userService)
        {
            _userService = userService;
        }

        /*[AllowAnonymous]
        [HttpGet("{username}")]
        public IActionResult GetUser(String username)
        {
            try
            {
                var user = _userService.GetUser(username);
                return Ok(user);
            }
            catch(Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }*/

        [AllowAnonymous]
        [HttpPost("register")]
        public IActionResult Register([FromBody]User user)
        {
            try
            {
                var userex = _userService.GetUser(user.Username);
                if (userex == null)
                {
                    // create user
                    _userService.Register(user);
                    var newUser = _userService.Authenticate(user.Username, user.Password);
                    return Ok(newUser);
                }
                else
                    return BadRequest(new { message = "Username already exists!" });
            }
            catch (Exception ex)
            {
                // return error message if there was an exception
                return BadRequest(new { message = ex.Message });
            }
        }

        [AllowAnonymous]
        [HttpPost("authenticate")]
        public IActionResult Authenticate([FromBody]AuthModel model)
        {
            try
            {
                var user = _userService.Authenticate(model.Username, Hash.ComputeSha256Hash(model.Password).ToUpper());

                if (user == null)
                    return BadRequest(new { message = "Username or password is incorrect" });

                return Ok(user);
            }
            catch(Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
        [HttpPost("update")]
        public IActionResult UpdateUser([FromBody]User user)
        {
            try
            {
                return Ok(_userService.Update(user));
            }
            catch(Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
        
        [HttpPost("delete")]
        public IActionResult DeleteUser([FromBody]User user)
        {
            try
            {
                _userService.Delete(user);
                return Ok();
            }
            catch(Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

    }
}