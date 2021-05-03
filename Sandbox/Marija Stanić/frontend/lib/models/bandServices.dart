import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/band.dart';

class BandServices {
  static String bandURL = "http://10.0.2.2:58210/Band"; // URL za API 

  static Future<List<Band>> getBands() async {
    http.Response response = await http.get(bandURL);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Band> bands = new List<Band>();

      for (var band in data) {
        bands.add(Band.fromJSON(band));
      }

      return bands;
    }

    return null;
  }

  static Map<String, String> header = {
    'Content-type' : 'application/json',
    'Accept' : 'application/json'
  };

  static Future<bool> addBand(Band band) async {
    var myBand = band.toMap(); // konvertujemo u JSON
    var bandBody = json.encode(myBand);
    var res = await http.post(bandURL, headers: header, body: bandBody); // saljemo objekat kao u POSTMAN-u, i on se dodaje na osnovu f-je u backend-u
    print(res.body);
    // ako je sve u redu, statusCode = 200; u suprotnom je 400+
    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<Band> getBand(String email, String password) async {
    // za slucaj kad se izvlace podaci iz text field-a
    email = email.trim();
    password = password.trim();

    // URL: Band/email/password
    var res = await http.get(bandURL + "/" + email + "/" + password, headers: header);

    print(email);
    print(password);

    final Map parsed = json.decode(res.body);
    return Band.fromJSON(parsed);
  }

  static Future<bool> checkRegistration(String email) async {
    email = email.trim();

    var res = await http.get(bandURL + "/" + email, headers: header);

    final Map parsed = json.decode(res.body);
    Band band = Band.fromJSON(parsed);

    if(band.id == null) 
      return true;

    return false;
  }
}