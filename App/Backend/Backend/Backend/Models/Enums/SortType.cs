using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.Enums
{
    public enum SortType {
        [field: Description("dates_asc")]
        dates_asc,
        [field: Description("dates_desc")]
        dates_desc,
        [field: Description("leaves_asc")]
        leaves_asc,
        [field: Description("leaves_desc")]
        leaves_desc,
        [field: Description("comments_asc")]
        comments_asc,
        [field: Description("comments_desc")]
        comments_desc 
    }
}
