using Backend.Utils;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UploadUserImage
    {
        public string Username { get; set; }
        public string ImageName { get; set; }
        public string OldImageName { get; set; }
        [JsonConverter(typeof(Base64FileJsonConverter))]
        public byte[] ImageData { get; set; }
    }
}
