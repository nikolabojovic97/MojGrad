using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Models
{
    public class BandMember
    {
        public int ID { get; set; }
        public int BandID { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }
    }
}
