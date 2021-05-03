using System;
using System.Collections.Generic;

namespace backApp.Moduls
{
    public partial class User
    {
        public long Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }

        public string Ime { get; set; }
        public string Prezime { get; set; }
    }
}
