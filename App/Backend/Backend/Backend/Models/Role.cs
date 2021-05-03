using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Role
    {
        public long RoleID { get; set; }
        [MaxLength(30)]
        public string Name { get; set; }
    }
}
