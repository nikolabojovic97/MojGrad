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
    public class BandMemberController : ControllerBase
    {
        private readonly IBandMemberService _bandMemberService;

        public BandMemberController(IBandMemberService bandMemberService)
        {
            _bandMemberService = bandMemberService;
        }

        [HttpPost]
        public void AddNewBandMember(BandMember bandMember)
        {
            _bandMemberService.AddBandMember(bandMember);
        }

        [HttpGet("{id}")]
        public IActionResult GetAllBandMembersByBandID(int id)
        {
            var res = _bandMemberService.GetAllMembersByBandID(id);

            if (res == null)
                return NotFound();

            return Ok(res);
        }

        [HttpDelete("{id}")]
        public void DeleteBandMember(int id)
        {
            _bandMemberService.DeleteBandMember(id);
        }
    }
}