import 'dart:convert';
import 'package:frontend/models/bandMember.dart';
import 'package:http/http.dart' as http;

class BandMemberServices {
  static String bandURL = "http://10.0.2.2:58210/BandMember"; // URL za API 

  static Future<List<BandMember>> getMembersByBandID(int id) async {
    http.Response response = await http.get(bandURL + "/" + id.toString());

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<BandMember> members = new List<BandMember>();

      for (var member in data) {
        members.add(BandMember.fromJSON(member));
      }

      return members;
    }

    return null;
  }

  static Map<String, String> header = {
    'Content-type' : 'application/json',
    'Accept' : 'application/json'
  };

  static Future<bool> addBandMember(BandMember member) async {
    var myMember = member.toMap(); // konvertujemo u JSON
    var memberBody = json.encode(myMember);
    var res = await http.post(bandURL, headers: header, body: memberBody); // saljemo objekat kao u POSTMAN-u, i on se dodaje na osnovu f-je u backend-u
    
    // ako je sve u redu, statusCode = 200; u suprotnom je 400+
    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<bool> deleteBandMember(int id) async {
    // URL: Band/email/password
    var res = await http.delete(bandURL + "/" + id.toString(), headers: header);

    // ako je sve u redu, statusCode = 200; u suprotnom je 400+
    return Future.value(res.statusCode == 200 ? true : false);
  }
}