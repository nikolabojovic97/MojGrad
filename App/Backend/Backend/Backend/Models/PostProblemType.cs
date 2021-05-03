using Backend.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostProblemType
    {
        public int Id { get; set; }
        public int PostId { get; set; }
        public ProblemType ProblemType { get; set; }
    }
}
