using Backend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Services.Interfaces
{
    public interface IMailSender
    {
        public bool SendEmailPasswordRecovery(User user);
        public bool SendEmailNewAdmin(User user);
        public bool SendEmailNewVerifiedInstitution(User user);
        public bool SendEmailNewUser(User user, string url);
    }
}
