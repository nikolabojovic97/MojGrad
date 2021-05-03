using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Models;

namespace WebApi.Services
{
    public interface IBandMemberService
    {
        public void AddBandMember(BandMember bandMember);
        public IEnumerable<BandMember> GetAllMembersByBandID(int id);
        public void DeleteBandMember(int id);
    }
}
