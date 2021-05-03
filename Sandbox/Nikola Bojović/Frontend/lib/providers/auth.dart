import 'dart:convert';
import 'package:Frontend/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String baseAccountURL = "http://127.0.0.1:44332/Account/";

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _username;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<String> authenticate(String username, String password) async {
    String url = baseAccountURL + "authenticate";
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"username": username, "password": password}));
    return checkResponse(response);
  }

  Future<String> register(User user) async {
    String url = baseAccountURL + "register";
    var data = {
      "firstname": user.FirstName,
      "lastname": "",
      "username": user.Username,
      "password": user.Password,
      "token": ""
    };
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));
    return checkResponse(response);
  }

  String checkResponse(response) {
    if (response.statusCode == 200) {
      var user = json.decode(response.body);
      _token = user["token"];
      var now = DateTime.now();
      _expiryDate = now.add(Duration(days: 7));
      _username = user["username"];
      notifyListeners();

      return null;
    } else
      return json.decode(response.body)["message"];
  }

  Future saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      "token": this._token,
      "expiryDate": this._expiryDate.toIso8601String(),
      "username": this._username
    });
    prefs.setString("userData", userData);
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("userData"))
      return false;

    final userData = prefs.getString("userData") as Map<String, Object>;
    final expiryDate = DateTime.parse(userData["expiryDate"]);

    if(expiryDate.isBefore(DateTime.now()))
      return false;

    _token = userData["token"];
    _username = userData["username"];
    _expiryDate = userData["expiryDate"];
    notifyListeners();
    return true;
  }
}
