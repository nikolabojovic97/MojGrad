using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Data;
using WebApi.Models;

namespace WebApi.Services
{
    public class BandService : IBandService
    {
        private ApplicationDbContext _db;
        private IConfiguration _configuration;

        public BandService(ApplicationDbContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        public void AddNewBand(Band band)
        {
            _db.Band.Add(band);
            _db.SaveChanges();
        }

        public IEnumerable<Band> GetAllBands()
        {
            return _db.Band;
        }

        public Band GetBand(string email, string password)
        {
            return _db.Band.Where(x => x.Email == email && x.Password == password).FirstOrDefault();
        }

        public Band GetBandByID(string email)
        {
            return _db.Band.Where(x => x.Email == email).FirstOrDefault();
        }
    }
}
