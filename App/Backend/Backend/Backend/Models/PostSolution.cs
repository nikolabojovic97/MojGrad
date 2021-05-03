using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostSolution
    {
        [Key]
        public int Id { get; set; }
        public int PostProblemId { get; set; }
        public int PostSolutionId { get; set; }
    }
}
