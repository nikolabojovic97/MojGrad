
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Utils
{
    public class Base64FileJsonConverter : JsonConverter
    {
        public override bool CanConvert(Type typeToConvert)
        {
            return typeToConvert == typeof(string);
        }

        public override object ReadJson(JsonReader reader, Type typeToConvert, object existingValue, JsonSerializer serializer)
        {
            return Convert.FromBase64String(reader.Value as string);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            throw new NotImplementedException();
        }
    }
}
