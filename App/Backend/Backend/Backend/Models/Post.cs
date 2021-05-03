using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Post
    {
        [Key]
        public int Id { get; set; }
        public string UserName { get; set; }
        public string Description { get; set; }
        [NotMapped]
        public int LeafNumber { get; set; }
        public string Location { get; set; }
        public string LatLng { get; set; }
        public string Address { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime LastTimeModify { get; set; }
        public string InstitutionUserName { get; set; }
        [NotMapped]
        public bool IsLiked { get; set; }
        [NotMapped]
        public string UserImageUrl { get; set; }
        [NotMapped]
        public IEnumerable<String> ImgUrl { get; set; }
        [NotMapped]
        public int ReportsNumber { get; set; }
        [NotMapped]
        public int CommentsNumber { get; set; }
        [NotMapped]
        public bool IsSolved { get; set; }
        [NotMapped]
        public bool isSolution { get; set; }
    }
}
