using Backend.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UploadPostImage
    {
        public string ImageName { get; set; }
        public int PostId { get; set; }
        //[JsonConverter(typeof(Base64FileJsonConverter))]
        public IEnumerable<string> ImageData { get; set; }
    }
}
