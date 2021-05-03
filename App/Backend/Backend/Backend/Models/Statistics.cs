using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Statistics
    {
        public long UserNumber { get; set; }
        public long SolutionNumber { get; set; }
        public long PostNumber { get; set; }
        public long ReactionNumber { get; set; }
        public long CommentNumber { get; set; }
        public long ReportNumber { get; set; }
        public long LatestPostNumber { get; set; }
        public long LatestReactionNumber { get; set; }
        public long LatestCommentNumber { get; set; }
        public long LatestReportNumber { get; set; }
        public List<double> DailyPosts { get; set; }
        public List<double> DailyLikes { get; set; }
        public List<double> ProblemTypes { get; set; }
    }
}
