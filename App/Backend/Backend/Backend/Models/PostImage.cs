using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostImage
    {
        [Key]
        public int Id { get; set; }
        public int PostId { get; set; }
        public string ImageUrl { get; set; }
    }
}
