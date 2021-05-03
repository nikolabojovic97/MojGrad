using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostLike
    {
        [Key]
        public int Id { get; set; }
        public int PostId { get; set; }
        public String UserName { get; set; }
        public DateTime Time { get; set; }
    }
}
