using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostComment
    {
        [Key]
        public int Id { get; set; }
        public string UserName { get; set; }
        public int PostId { get; set; }
        public String Comment { get; set; }
        public DateTime DateCreated { get; set; }
        [NotMapped]
        public string UserImgUrl { get; set; }
        [NotMapped]
        public int ReportsNumber { get; set; }
    }
}
