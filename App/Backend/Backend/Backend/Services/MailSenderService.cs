using Backend.Models;
using Backend.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace Backend.Services
{
    public class MailSenderService : IMailSender
    {
        private IConfiguration configuration;
        private string email;
        private string password;
        private string appName;
        private NetworkCredential login;
        private SmtpClient client;

        public MailSenderService(IConfiguration configuration)
        {
            this.configuration = configuration;
            email = configuration.GetSection("MailSender").GetSection("Email").Value;
            password = configuration.GetSection("MailSender").GetSection("Password").Value;
            appName = configuration.GetSection("MailSender").GetSection("AppName").Value;
            initConnection();
        }

        private void initConnection()
        {
            login = new NetworkCredential(email, password);
            client = new SmtpClient("smtp.gmail.com");
            client.Port = 587;
            client.EnableSsl = true;
            client.Credentials = login;
        }

        private string RecoveryPasswordMessageBody(string username, string password) { 
            var body = System.IO.File.ReadAllText("./Utils/EmailTemplates/PasswordRecovery.html");
            body = body.Replace("#USERNAME#", username);
            body = body.Replace("#PASSWORD#", password);
            return body;
        }

        public bool SendEmailPasswordRecovery(User user)
        {
            string subject = "Zaboravljena lozinka";
            MailMessage message;
            initConnection();
            try
            {
                message = new MailMessage();
                message.From = new MailAddress(email, appName, Encoding.UTF8);
                message.To.Add(new MailAddress(user.Email));
                message.Priority = MailPriority.High;
                message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                message.IsBodyHtml = true;
                message.Subject = subject;
                message.Body = RecoveryPasswordMessageBody(user.Username, user.Password);
                client.Send(message);
            }
            catch(Exception e)
            {
                Console.Out.Write(e.Message);
                return false;
            }
            return true;
        }

        private string NewAdminMessageBody(string username, string password)
        {
            var body = System.IO.File.ReadAllText("./Utils/EmailTemplates/NewAdmin.html");
            body = body.Replace("#USERNAME#", username);
            body = body.Replace("#PASSWORD#", password);
            return body;
        }

        public bool SendEmailNewAdmin(User user)
        {
            string subject = "Admin nalog";
            MailMessage message;
            initConnection();
            try
            {
                message = new MailMessage();
                message.From = new MailAddress(email, appName, Encoding.UTF8);
                message.To.Add(new MailAddress(user.Email));
                message.Priority = MailPriority.High;
                message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                message.IsBodyHtml = true;
                message.Subject = subject;
                message.Body = NewAdminMessageBody(user.Username, user.Password);
                client.Send(message);
            }
            catch(Exception e)
            {
                Console.Out.Write(e.Message);
                return false;
            }
            return true;
        }

        private string NewVerifiedInstitutionMessageBody(string username)
        {
            var body = System.IO.File.ReadAllText("./Utils/EmailTemplates/NewVerifiedInstitution.html");
            body = body.Replace("#USERNAME#", username);
            return body;
        }

        public bool SendEmailNewVerifiedInstitution(User user)
        {
            string subject = "Uspešno verifikovan nalog";
            MailMessage message;
            initConnection();
            try
            {
                message = new MailMessage();
                message.From = new MailAddress(email, appName, Encoding.UTF8);
                message.To.Add(new MailAddress(user.Email));
                message.Priority = MailPriority.High;
                message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                message.IsBodyHtml = true;
                message.Subject = subject;
                message.Body = NewVerifiedInstitutionMessageBody(user.Username);
                client.Send(message);
            }
            catch (Exception e)
            {
                Console.Out.Write(e.Message);
                return false;
            }
            return true;
        }

        private string NewUserMessageBody(string username, string url)
        {
            var body = System.IO.File.ReadAllText("./Utils/EmailTemplates/NewUser.html");
            body = body.Replace("#USERNAME#", username);
            body = body.Replace("#URL#", url);
            return body;
        }

        public bool SendEmailNewUser(User user, string url)
        {
            string subject = "Verifikacija naloga";
            MailMessage message;
            initConnection();
            try
            {
                message = new MailMessage();
                message.From = new MailAddress(email, appName, Encoding.UTF8);
                message.To.Add(new MailAddress(user.Email));
                message.Priority = MailPriority.High;
                message.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;
                message.IsBodyHtml = true;
                message.Subject = subject;
                message.Body = NewUserMessageBody(user.Username, url);
                client.Send(message);
            }
            catch (Exception e)
            {
                Console.Out.Write(e.Message);
                return false;
            }
            return true;
        }
    }
}
