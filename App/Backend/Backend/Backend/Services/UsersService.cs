using Backend.Data;
using Backend.Models;
using Backend.Models.Enums;
using Backend.Services.Interfaces;
using Backend.Utils;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Backend.Services
{
    public class UsersService : IUsersService
    {
        private ApplicationDbContext db;
        private readonly IConfiguration configuration;
        private IMailSender mailSender;

        public UsersService(ApplicationDbContext db, IConfiguration configuration, IMailSender mailSender)
        {
            this.db = db;
            this.configuration = configuration;
            this.mailSender = mailSender;
        }

        public async Task<User> CreateAsync(User u)
        {
            u.Password = Hash.ComputeSha256Hash(u.Password).ToUpper();

            await db.Users.AddAsync(u);
            await db.SaveChangesAsync();

            return u;
        }

        public Task<IEnumerable<User>> RetrieveAllAsync()
        {
            return Task.Run<IEnumerable<User>>(() =>
            {
                var users = db.Users.ToList();
                foreach (var user in users)
                    user.Password = "";
                return users;
            });
        }

        public Task<IEnumerable<User>> RetriveAllForVerification()
        {
            return Task.Run<IEnumerable<User>>(async () =>
            {
                IEnumerable<User> users = await RetrieveAllAsync();
                var institutionRole = db.Roles.Where(r => r.Name.ToLower() == "institution").FirstOrDefault();
                return users.Where(u => u.isVerify == false && u.RoleID == institutionRole.RoleID);
            });
        }

        public Task<User> RetrieveAsync(string username)
        {
            return Task.Run(() =>
            {
                User u = db.Users.AsNoTracking().Where(x => x.Username == username).FirstOrDefault();
       
                return u;
            });
        }

        public Task<User> RetrieveUserByMailAsync(string email)
        {
            return Task.Run(() =>
            {
                User u = db.Users.AsNoTracking().Where(x => x.Email == email).FirstOrDefault();

                return u;
            });
        }

        public async Task<User> UpdateAsync(string username, User u)
        {
            return await Task.Run(async () =>
             {
                 db.Users.Update(u).Property(x => x.Password).IsModified = false;
                 await db.SaveChangesAsync();

                 return await AuthenticateAsync(new Auth { Username = u.Username, Password = u.Password });
             });
        }

        public Task<User> PatchAsync(string username, JsonPatchDocument<User> u)
        {
            return null;
        }
        
        public async Task<bool> SaveImageAsync(string username, string imgName, string oldImageName, string path, byte[] imageData)
        {
            var imageName = username + imgName + ".png";
            var newPath = Path.Combine(path, imageName);
            var deletePath = Path.Combine(path, oldImageName);
            await File.WriteAllBytesAsync(newPath, imageData);
            if (oldImageName != "" && !oldImageName.Contains("http://") && !oldImageName.Contains("https://"))
                 File.Delete(deletePath);
            

            var user = await db.Users.FindAsync(username);
            user.ImgUrl = imageName;
            await UpdateAsync(username, user);

            return true;
        }

        public async Task<bool?> DeleteAsync(string username)
        {
            User u = db.Users.Find(username);

            IEnumerable<PostLike> postLikes = db.PostLikes.Where(pl => pl.UserName == username);
            if (postLikes != null)
            {
                foreach (var like in postLikes)
                    db.PostLikes.Remove(like);
            }

            IEnumerable<PostComment> postComments = db.PostComments.Where(pc => pc.UserName == username);
            if (postComments != null)
            {
                foreach (var comment in postComments)
                {
                    db.PostComments.Remove(comment);
                }
            }

            db.Users.Remove(u);
            int affected = await db.SaveChangesAsync();

            return affected > 0;
        }

        public void DeleteUserImage(string username, String path)
        {
            User u = db.Users.Find(username);
            if (u.ImgUrl != "no-image.png" && u.ImgUrl != "no-image-institution.png" && !u.ImgUrl.Contains("http://") && !u.ImgUrl.Contains("https://"))
            {
                var deletePath = Path.Combine(path, u.ImgUrl);
                File.Delete(deletePath);
            }
        }

        public Task<User> AuthenticateAsync(Auth a)
        {
            return Task.Run(async () =>
            {
                User u = await db.Users.FindAsync(a.Username);
                if (u != null)
                    if (u.Username == a.Username && (u.Password == Hash.ComputeSha256Hash(a.Password).ToUpper() || u.Password == a.Password))
                    {
                        var tokenHandler = new JwtSecurityTokenHandler();
                        var key = Encoding.ASCII.GetBytes(configuration.GetValue<string>("Secret"));
                        var tokenDescriptor = new SecurityTokenDescriptor
                        {
                            Subject = new ClaimsIdentity(new Claim[]
                            {
                                new Claim(ClaimTypes.Name, u.Username),
                                new Claim(ClaimTypes.Role, db.Roles.Where(x => x.RoleID == u.RoleID).FirstOrDefault().Name)
                            }),
                            Expires = DateTime.UtcNow.AddDays(30),
                            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                        };
                        var token = tokenHandler.CreateToken(tokenDescriptor);
                        u.Token = tokenHandler.WriteToken(token);
                        u.Password = "";
                        return u;
                    }

                return null;
            });
        }

        public async Task<double> CalculateUserReportValidity(string username)
        {
            return await Task.Run(() =>
            {
                var numberOfPostReports = db.PostReports.Where(x => x.UserName == username).Count();
                var numberOfCommentReports = db.CommentReports.Where(x => x.UserName == username).Count();
                var numberOfReports = numberOfPostReports + numberOfCommentReports;

                var approvedPostReports = db.PostReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Approved).Count();
                var approvedCommentReports = db.CommentReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Approved).Count();
                var approved = approvedPostReports + approvedCommentReports;

                var pendingPostReports = db.PostReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Pending).Count();
                var pendingCommentReports = db.CommentReports.Where(x => x.UserName == username && x.ReportStatus == ReportStatus.Pending).Count();
                var pending = pendingPostReports + pendingCommentReports;

                double tmp = numberOfReports - pending;
                double validity = 0;

                if (tmp != 0)
                    validity = approved / tmp;

                return validity * 100;
            });
        }

        public Task<IEnumerable<User>> RetrieveAllRegularUsers(String username)
        {
            return Task.Run<IEnumerable<User>>(async () =>
            {
                var userRole = db.Roles.Where(x => x.Name == "User").Select(x => x.RoleID).FirstOrDefault();
                IEnumerable<User> users;

                if (username != null)
                    users = db.Users.Where(x => x.RoleID == userRole && x.Username != username).ToList();
                else
                    users = db.Users.Where(x => x.RoleID == userRole).ToList();

                foreach (var user in users)
                {
                    user.Password = "";
                    user.ReportValidity = await CalculateUserReportValidity(user.Username);
                }
                return users;
            });
        }

        public Task<IEnumerable<User>> RetrieveAllAdminUsers(string username)
        {
            return Task.Run<IEnumerable<User>>(() =>
            {
                var adminRole = db.Roles.Where(x => x.Name == "Admin").Select(x => x.RoleID).FirstOrDefault();
                IEnumerable<User> users;

                if (username != null)
                    users = db.Users.Where(x => x.RoleID == adminRole && x.Username != username).ToList();
                else
                    users = db.Users.Where(x => x.RoleID == adminRole).ToList();

                foreach (var user in users)
                    user.Password = "";
                return users;
            });
        }

        public async Task<bool> VerifyInstitution(string adminUserName, string institutionUserName)
        {
            User admin = db.Users.AsNoTracking().Where(a => a.Username == adminUserName).FirstOrDefault();
            var adminRole = db.Roles.Where(r => r.Name.ToLower() == "admin").FirstOrDefault();

            if (admin != null && admin.RoleID.Equals(adminRole.RoleID)) 
            {
                User institution = db.Users.AsNoTracking().Where(i => i.Username == institutionUserName).FirstOrDefault();
                var institutionRole = db.Roles.Where(r => r.Name.ToLower() == "institution").FirstOrDefault();
                
                if(institution != null && institution.RoleID.Equals(institutionRole.RoleID))
                {
                    institution.isVerify = true;
                    db.Users.Attach(institution).Property(u => u.isVerify).IsModified = true;
                    await db.SaveChangesAsync();

                    SendVerificationMailToInstitution(institution);

                    return true;
                }
            }
            return false;
        }

        public Task<bool> SendVerificationMailToInstitution(User user)
        {
            return Task.Run(() =>
            {
                return mailSender.SendEmailNewVerifiedInstitution(user);
            });
        }

        public Task<bool> SendVerificationMailToNewAdmin(User user)
        {
            return Task.Run(() =>
            {
                return mailSender.SendEmailNewAdmin(user);
            });
        }

        public Task<bool> VerifyUser(User user)
        {
            return Task.Run(async () =>
            {
                user.isVerify = true;
                db.Users.Update(user).Property(x => x.Password).IsModified = false;
                await db.SaveChangesAsync();

                return true;
            });
        }

        public Task<bool> SendVerificationMailToUser(User user, string url)
        {
            return Task.Run(() =>
            {
                return mailSender.SendEmailNewUser(user, url);
            });
        }

        public Task<string> UserVerificationResponse(string status)
        {
            return Task.Run(() =>
            {
                var response = System.IO.File.ReadAllText("./Utils/EmailTemplates/UserVerificationResponse.html");
                response = response.Replace("#STATUS#", status);
                return response;
            });
        }

        public Task<IEnumerable<User>> RetriveAllVerifyInstitutions()
        {
            return Task.Run(async () =>
            {
                var institutionRole = db.Roles.Where(r => r.Name.ToLower() == "institution").FirstOrDefault();

                IEnumerable<User> verifyInstitutions = db.Users.Where(u => u.RoleID == institutionRole.RoleID && u.isVerify == true);

                foreach (var institution in verifyInstitutions)
                {
                    institution.Password = "";
                    institution.ReportValidity = await CalculateUserReportValidity(institution.Username);
                }

                return verifyInstitutions;
            });
        }

        public Task<bool> SendPasswordRecoveryAsync(User user)
        {
            return Task.Run(async () =>
            {
                var password = Hash.ComputeSha256Hash(DateTime.UtcNow.ToString()).Substring(10,10).ToUpper();
                user.Password = Hash.ComputeSha256Hash(password).ToUpper();

                db.Users.Update(user);
                await db.SaveChangesAsync();

                user.Password = password;
                return mailSender.SendEmailPasswordRecovery(user);
            });
        }
    }
}
