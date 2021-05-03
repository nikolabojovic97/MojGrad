using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Services.Interfaces;
using Backend.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private IUsersService usersService;
        private IWebHostEnvironment env;

        public UsersController(IUsersService usersService, IWebHostEnvironment env)
        {
            this.usersService = usersService;
            this.env = env;
        }

        // GET: api/users
        // GET: api/users/?city=[country]
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(IEnumerable<User>))]
        [ProducesResponseType(401)]
        public async Task<IEnumerable<User>> GetUsers(string city)
        {
            if (string.IsNullOrWhiteSpace(city))
                return await usersService.RetrieveAllAsync();
            else
                return (await usersService.RetrieveAllAsync()).Where(user => user.City == city);
        }

        // GET: api/users/[id]
        [AllowAnonymous]
        [HttpGet("{username}", Name = nameof(GetUser))]
        [ProducesResponseType(200, Type = typeof(User))]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> GetUser(string username)
        {
            User u = await usersService.RetrieveAsync(username);
            
            if (u == null)
                return NoContent();

            u.Password = "";
            return Ok(u);
        }

        // GET: api/Users/forVerification
        [Authorize(Roles = "Admin")]
        [HttpGet("forVerification")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<User>))]
        [ProducesResponseType(401)]
        public async Task<IEnumerable<User>> GetUsersForVerification()
        {
            return await usersService.RetriveAllForVerification();
        }

        // GET: api/Users/verifyInstitutions
        [HttpGet("verifyInstitutions")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<User>))]
        [ProducesResponseType(401)]
        public async Task<IEnumerable<User>> GetAllVerifyInstitutions()
        {
            return await usersService.RetriveAllVerifyInstitutions();
        }

        // POST: api/users
        // BODY: User (JSON, XML)
        [AllowAnonymous]
        [HttpPost]
        [ProducesResponseType(200, Type = typeof(User))]
        [ProducesResponseType(400)]
        public async Task<IActionResult> Create([FromBody] User u)
        {
            var password = u.Password;

            if (u == null)
                return BadRequest("Došlo je do greške prilikom registracije korisnika. Pokušajte kasnije.");

            var existing = await usersService.RetrieveAsync(u.Username);
            if (existing != null)
                return BadRequest($"Korisnik sa koriničkim imenom {u.Username} već postoji.");

            existing = await usersService.RetrieveUserByMailAsync(u.Email);
            if (existing != null)
                return BadRequest($"Korisnik sa mejl adresom {u.Email} već postoji.");

            User added = await usersService.CreateAsync(u);
            
            if(added == null)
                return BadRequest("Došlo je do greške prilikom registracije korisnika. Pokušajte kasnije.");

            if (u.RoleID == 0)
            {
                usersService.SendVerificationMailToUser(added, $"http://147.91.204.116:2057/api/Users/verify/{u.Username}/{Hash.ComputeSha256Hash(u.Email)}");
                return Ok($"Korisnik {u.Username} je uspešno kreiran. Na Vašu email adresu je poslat mejl za verifikaciju.");
            }
            else if (u.RoleID == 1)
            {
                User temp = u;
                temp.Password = password;
                usersService.SendVerificationMailToNewAdmin(temp);
                return Ok($"Administrator {u.Username} je uspešno kreiran. Na njegovu email adresu je poslat mejl sa podacima potrebnim za prijavu.");
            }

            return Ok();
        }

        

        // POST: api/Users/username=[username]/image
        [HttpPost("{username}/image")]
        public async Task<IActionResult> SaveImage(string username, [FromBody]UploadUserImage obj)
        {
            if (!username.Equals(obj.Username))
                return BadRequest(new { message = "Username error!" });

            if (await usersService.RetrieveAsync(username) == null)
                return BadRequest(new { message = "Username doesn't exist!" });
            
            if(obj.ImageData.Length > 0)
            {
                //CHECK TIME SINCE LAST PROFILE IMAGE CHANGING

                var path = Path.Combine(env.WebRootPath, "src", "Users");
                await usersService.SaveImageAsync(username, obj.ImageName, obj.OldImageName, path, obj.ImageData);    

                return Ok();
            }
            return BadRequest(new { message = "Something is wrong with image!" });
        }

        // PUT: api/users/[id]
        // BODY: User (JSON, XML)
        [HttpPut("{username}")]
        [ProducesResponseType(200, Type = typeof(User))]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> Update(string username, [FromBody] User u)
        {
            if (u == null)
                return BadRequest();

            if (u.Username != username)
                return BadRequest();

            var existing = await usersService.RetrieveAsync(username);
            if (existing == null)
                return NotFound();

            var updated = await usersService.UpdateAsync(username, u);

            return Ok(updated);
        }

        // PATCH: api/users/[id]
        // BODY: User (JSON, XML)
        [HttpPatch("{username}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> Patch(string username, [FromBody] JsonPatchDocument<User> u)
        {
            if (u == null)
                return BadRequest();

            var x = await usersService.PatchAsync(username, u);

            return new NoContentResult();
        }

        // DELETE: api/users/[id]
        [Authorize(Roles = "Admin")]
        [HttpDelete("{username}")]
        [ProducesResponseType(204)]
        [ProducesResponseType(400)]
        [ProducesResponseType(401)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> Delete(string username)
        {
            var existing = await usersService.RetrieveAsync(username);
            if (existing == null)
                return NotFound();

            var path = Path.Combine(env.WebRootPath, "src", "Users");
            usersService.DeleteUserImage(username, path);
            bool? deleted = await usersService.DeleteAsync(username);
            if (deleted.HasValue && deleted.Value)
                return new NoContentResult();
            else
                return BadRequest($"User {username} was found but failed to delete.");
        }

        // POST: api/users/login
        // BODY: Auth (JSON, XML)
        [AllowAnonymous]
        [HttpPost("login")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> LogIn([FromBody] Auth a)
        {
            if (a == null)
                return BadRequest("Došlo je do greške prilikom prijave korisnika. Pokušajte kasnije.");

            var existing = await usersService.RetrieveAsync(a.Username);
            if (existing == null)
                return BadRequest($"Korisnik sa korisničkim imenom {a.Username} ne postoji.");

            if (!existing.isVerify)
                return BadRequest($"Korisnik sa korisničkim imenom {existing.Username} nije verifikovan.");

            var u_auth = await usersService.AuthenticateAsync(a);
            if (u_auth == null)
                return BadRequest("Neispravna lozinka.");

            return Ok(u_auth);
        }

        // GET: api/users/regularUsers
        // GET: api/users/regularUsers/?username=[username]
        [Authorize(Roles = "Admin")]
        [HttpGet("regularUsers")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<User>))]
        [ProducesResponseType(401)]
        public async Task<IEnumerable<User>> GetRegularUsers(String username)
        {
            return await usersService.RetrieveAllRegularUsers(username);
        }

        // GET: api/users/adminUsers
        // GET: api/users/adminUsers/?username=[username]
        [Authorize(Roles = "Admin")]
        [HttpGet("adminUsers")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<User>))]
        [ProducesResponseType(401)]
        public async Task<IEnumerable<User>> GetAdminUsers(String username)
        {
            return await usersService.RetrieveAllAdminUsers(username);
        }

        // POST: api/Users/verifyInstitution/adminUsername=[adminUsername]/institutionUsername=[institutionUsername]
        [Authorize(Roles = "Admin")]
        [HttpPost("verifyInstitution/{adminUserName}/{institutionUserName}")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        public async Task<IActionResult> VerifyInstitution(string adminUserName, string institutionUserName)
        {
            bool verified = await usersService.VerifyInstitution(adminUserName, institutionUserName);
            if(verified == true)
            {
                return Ok();
            }
            return BadRequest();
        }

        // GET: api/users/password/recovery/nikola
        [AllowAnonymous]
        [HttpGet("password/recovery/{username}")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> GetPasswordRecoveryEmail(string username)
        {
            var user = await usersService.RetrieveAsync(username);
            if (user == null)
                return NotFound($"Korisnik sa korisničkim imenom {username} ne postoji.");
            if (!user.isVerify)
                return BadRequest($"Korisnik sa korisničkim imenom {username} nije verifikovan.");
            var result = await usersService.SendPasswordRecoveryAsync(user);
            if (result == true)
                return Ok("Na Vašu email adresu je poslata poruka sa uputstvima za pristupanje nalogu.");
            return BadRequest("Došlo je do greške, pokušajte kasnije.");
        }

        [AllowAnonymous]
        [HttpGet("verify/{username}/{hash}")]
        [ProducesResponseType(200)]
        [ProducesResponseType(400)]
        [ProducesResponseType(404)]
        public async Task<ContentResult> VerifyUser(string username, string hash)
        {
            String status;
            var user = await usersService.RetrieveAsync(username);

            if (user == null)
                status = $"Korisnik sa korisničkim imenom {username} ne postoji.";
            else if (user.isVerify)
                status = $"Korisnik sa korisničkim imenom {username} je već verifikovan.";
            else if (hash != Hash.ComputeSha256Hash(user.Email))
                status = "Zahtev za verifikaciju nije validan.";
            else if (await usersService.VerifyUser(user))
                status = $"Korisnik {username} je uspešno verifikovan.";
            else status = "Došlo je do greške prilikom verifikacije korisnika.";

            return Content(await usersService.UserVerificationResponse(status), "text/html", Encoding.UTF8);
        }

    }
}