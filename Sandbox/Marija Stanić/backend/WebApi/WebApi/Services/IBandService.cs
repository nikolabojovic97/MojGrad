using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Models;

namespace WebApi.Services
{
    public interface IBandService
    {
        public void AddNewBand(Band band);
        public Band GetBandByID(string email);
        public IEnumerable<Band> GetAllBands();
        public Band GetBand(String email, String password);
    }
}
