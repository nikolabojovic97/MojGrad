using Backend.Models;
using Microsoft.AspNetCore.JsonPatch;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services.Interfaces
{
    public interface IUsersService
    {
        Task<User> CreateAsync(User u);
        Task<IEnumerable<User>> RetrieveAllAsync();
        Task<User> RetrieveAsync(string id);
        public Task<User> RetrieveUserByMailAsync(string email);
        Task<User> UpdateAsync(string id, User u);
        Task<User> PatchAsync(string username, JsonPatchDocument<User> u);
        Task<bool?> DeleteAsync(string id);
        public Task<User> AuthenticateAsync(Auth a);
        public Task<bool> SaveImageAsync(string username, string imgName, string oldImageName, string imagePath, byte[] imageData);
        public Task<IEnumerable<User>> RetrieveAllRegularUsers(string username);
        public Task<IEnumerable<User>> RetrieveAllAdminUsers(string username);
        public void DeleteUserImage(string username, String path);
        public Task<bool> VerifyInstitution(string adminUserName, string institutionUserName);
        public Task<IEnumerable<User>> RetriveAllForVerification();
        public Task<IEnumerable<User>> RetriveAllVerifyInstitutions();
        public Task<bool> SendPasswordRecoveryAsync(User user);
        public Task<double> CalculateUserReportValidity(string username);
        public Task<bool> VerifyUser(User user);
        public Task<bool> SendVerificationMailToUser(User user, string url);
        public Task<string> UserVerificationResponse(string status);
        public Task<bool> SendVerificationMailToInstitution(User user);
        public Task<bool> SendVerificationMailToNewAdmin(User user);
    }
}
