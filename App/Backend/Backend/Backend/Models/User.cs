using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Backend.Models
{
    public class User
    {
        public User()
        {

        }

        public User(User u)
        {
            Username = u.Username;
            Name = u.Name;
            Email = u.Email;
            Password = u.Password;
            City = u.City;
            Phone = u.Phone;
            Token = u.Token;
            RoleID = u.RoleID;
        }


        [Key]
        [Required]
        [MaxLength(30)]
        public string Username { get; set; }
        [Required]
        [MaxLength(60)]
        public string Name { get; set; }
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        [Required]
        public string Password { get; set; }
        public string ImgUrl { get; set; }
        public string Bio { get; set; }
        [Required]
        [MaxLength(30)]
        public string City { get; set; }
        [MaxLength(30)]
        public string Phone { get; set; }
        [NotMapped]
        public string Token { get; set; }
        public long RoleID { get; set; } = 0;
        public bool isVerify { get; set; } = false;
        [NotMapped]
        public bool isVerifyInsitution { get; set; }
        [NotMapped]
        public double ReportValidity { get; set; }
    }
}
