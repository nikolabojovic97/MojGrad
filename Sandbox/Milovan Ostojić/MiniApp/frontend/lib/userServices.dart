import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/user.dart';

class UserServices {
  static String userURL = "http://127.0.0.1:58210/User"; // URL za API 

  static Future<List<User>> getUsers() async {
    http.Response response = await http.get(userURL);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<User> users = new List<User>();

      for (var user in data) {
        users.add(User.fromJSON(user));
      }

      return users;
    }

    return null;
  }

  static Map<String, String> header = {
    'Content-type' : 'application/json',
    'Accept' : 'application/json'
  };

  static Future<bool> addUser(User user) async {
    var myUser = user.toMap(); // konvertujemo u JSON
    var userBody = json.encode(myUser);
    var res = await http.post(userURL, headers: header, body: userBody); // saljemo objekat kao u POSTMAN-u, i on se dodaje na osnovu f-je u backend-u
    
    // ako je sve u redu, statusCode = 200; u suprotnom je 400+
    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<User> getUser(String email, String password) async {
    // za slucaj kad se izvlace podaci iz text field-a
    email = email.trim();
    password = password.trim();

    // URL: User/email/password
    var res = await http.get(userURL + "/" + email + "/" + password, headers: header);

    print(res.body);

    final Map parsed = json.decode(res.body);
    return User.fromJSON(parsed);
  }

  static Future<bool> checkRegistration(String email) async {
    email = email.trim();

    var res = await http.get(userURL + "/" + email, headers: header);

    final Map parsed = json.decode(res.body);
    var user = User.fromJSON(parsed);

    if(user.id == null) 
      return true;

    return false;
  }
}