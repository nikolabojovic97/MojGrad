using Backend.Models.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class CommentReport
    {
        [Key]
        public int Id { get; set; }
        public string UserName { get; set; }
        public int CommentId { get; set; }
        public DateTime DateReported { get; set; }
        [NotMapped]
        public string ReportedUserName { get; set; }
        [NotMapped]
        public int PostId { get; set; }
        [NotMapped]
        public int ReportsNumber { get; set; }
        public ReportStatus ReportStatus { get; set; }
        [NotMapped]
        public double ReportValidity { get; set; }
    }
}
