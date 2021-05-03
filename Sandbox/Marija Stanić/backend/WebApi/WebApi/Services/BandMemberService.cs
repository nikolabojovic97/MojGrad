using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Data;
using WebApi.Models;

namespace WebApi.Services
{
    public class BandMemberService : IBandMemberService
    {
        private ApplicationDbContext _db;
        private IConfiguration _configuration;

        public BandMemberService(ApplicationDbContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        public void AddBandMember(BandMember bandMember)
        {
            _db.BandMember.Add(bandMember);
            _db.SaveChanges();
        }

        public void DeleteBandMember(int id)
        {
            BandMember bandMember = _db.BandMember.Where(x => x.ID == id).FirstOrDefault();
            _db.BandMember.Remove(bandMember);
            _db.SaveChanges();
        }

        public IEnumerable<BandMember> GetAllMembersByBandID(int id)
        {
            return _db.BandMember.Where(x => x.BandID == id);
        }
    }
}
