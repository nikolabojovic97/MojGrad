using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApi.Models;
using WebApi.Services;

namespace WebApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class BandController : ControllerBase
    {
        private readonly IBandService _bandService;

        public BandController(IBandService bandService)
        {
            _bandService = bandService;
        }

        [HttpPost]
        public void AddNewBand(Band band)
        {
            _bandService.AddNewBand(band);
        }

        [HttpGet]
        public IActionResult GetAllBands()
        {
            var res = _bandService.GetAllBands();

            if (res == null)
                return NotFound();

            return Ok(res);
        }

        [HttpGet("{email}")]
        public IActionResult GetBandByID(string email)
        {
            var res = _bandService.GetBandByID(email);

            if (res == null)
                return NotFound();

            return Ok(res);
        }

        [HttpGet("{email}/{password}")]
        public IActionResult GetBand(String email, String password)
        {
            var res = _bandService.GetBand(email, password);

            if (res == null)
                return NotFound();

            return Ok(res);
        }
    }
}