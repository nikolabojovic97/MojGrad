import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:frontendWeb/models/uploadUserImage.dart';
import 'package:frontendWeb/utils/userSession.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';
import '../models/user.dart';

String baseURL = usersURL;

class UserService with ChangeNotifier {
  User _user;
  String _username;
  String _token;
  DateTime _expiryDate;

  String get username {
    return _username;
  }

  User get user {
    return _user;
  }

  // returns the token if it's valid, or null if it isn't
  String get token {
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null)
      return _token;
    return null;
  }

  bool get isAuthorized {
    if(Session.user != null) {
      _user = User.fromJSON(json.decode(Session.user));
      _token = _user.token;
      _expiryDate = DateTime.now().add(Duration(days: 2));
      _username = _user.username;

      if (token == null) {
        return false;
      }

      return true;
    }
    return false;
  }

  bool get isAdmin {
    if (_user.roleID == 1)
      return true;

    return false;
  }

  bool get isInstitution {
    if (_user.roleID == 2)
      return true;

    return false;
  }

  bool get isVerifiedInstitution {
    if (isInstitution && _user.isVerify == true) 
      return true;

    return false;
  }

  static Map<String, String> header = {
    'Content-type' : 'application/json',
    'Accept' : 'application/json'
  };

  // TOKEN
  // method that saves the token in Shared Preferences
  Future<bool> setUserToken() async {
    final preferences = await SharedPreferences.getInstance();
    final data = json.encode({"username": this._username, "token": this._token, "expirydate": this._expiryDate.toIso8601String()});

    return preferences.setString("tokenData", data);
  }

  // method that returns the token from Shared Preferences
  Future<String> getUserToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString("tokenData");
  }

  Future<bool> removeUserToken() async{
    Session.user = null;

    final preferences = await SharedPreferences.getInstance();
    return preferences.remove("tokenData");
  }

  // CHECK
  // server will return json encoded version of User within response body in case of a successful login/signup (statusCode = 200)
  // in that case, we should update the token 
  bool checkResponseStatus(response) {
    if(response.statusCode == 200) {

      var checkUser = User.fromJSON(json.decode(response.body));

      if (!(checkUser.roleID == 1 || (checkUser.roleID == 2 && checkUser.isVerify == true)))
        return null;

      _user = checkUser;
      _token = _user.token;
      _expiryDate = DateTime.now().add(Duration(days: 2));
      _username = _user.username;

      Session.user = response.body;

      setUserToken();

      return true;
    }

    return false; 
  }

  // LOGIN
  // auto login
  Future<bool> attemptAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();

    if(!preferences.containsKey("tokenData"))
      return false;

    final tokenData = getUserToken() as Map<String, Object>;
    final expiryDate = DateTime.parse(tokenData["expirydate"]);

    if(DateTime.now().isAfter(expiryDate))
      return false;

    _token = tokenData["token"];
    _username = tokenData["username"];
    _expiryDate = expiryDate;

    notifyListeners();

    return true;
  } 

  Future<bool> attemptLogin(String username, String password) async {
    var url = baseURL + "/login";

    var response = await http.post(url, headers: header, body: json.encode({"username": username, "password": password}));

    // returns null if everything is okay or error message if something went wrong 
    return checkResponseStatus(response);
  }

  void logout() async {
    _user = null;
    _username = null;
    _token = null;
    _expiryDate = null;

    removeUserToken();
  }

  // SIGN UP
  Future<bool> attemptSignUp(User user) async {
    var data = {
      "username": user.username,
      "name": user.name,
      "email": user.email,
      "password": user.password,
      "imgUrl": user.imgUrl,
      "bio": user.bio,
      "city": user.city,
      "phone": user.phone,
      "token": user.token,
      "roleID": user.roleID,
      "isVerify": user.isVerify,
      "isVerifyInstitution": false
    };

    var response = await http.post(baseURL, headers: header, body: json.encode(data));

    // returns null if everything is okay or error message if something went wrong 
    if(response.statusCode == 200) {
      return true;
    }

    return false; 
  }

  // ADD
  Future<bool> addNewAdminProfile(User user) async {
    var data = {
      "username": user.username,
      "name": user.name,
      "email": user.email,
      "password": user.password,
      "imgUrl": user.imgUrl,
      "bio": user.bio,
      "city": user.city,
      "phone": user.phone,
      "token": user.token,
      "roleID": user.roleID,
      "isVerify": true
    };

    var response = await http.post(baseURL, headers: header, body: json.encode(data));

    // returns null if everything is okay or error message if something went wrong 
    if(response.statusCode == 200) 
      return true;

    return false; 
  }

  // GET
  // we use this method to see someone's profile 
  Future<User> getUser(String username) async {
    Map<String, String> header = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + token
    };

    // in case we got the username from some text field
    username = username.trim();

    var url = baseURL + "/" + username;
    var response = await http.get(url, headers: header);
    
    if(response.statusCode != 200) 
      return null;

    final Map parsed = json.decode(response.body);
    return User.fromJSON(parsed);
  }

  static Future<String> getPasswordRecovery(String username) async {
    var url = passwordRecoveryEmailURL + username;
    
    var response = await http.get(url, headers: header);
    
    return response.body.replaceAll('\"', '').trim();
  }

  // UPDATE
  // users can update information about their account, or change their password
  Future<bool> updateUserAccount(User user) async {
    Map<String, String> authHeader = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    var url = baseURL + "/" + user.username;

    var data = {
      "username": user.username,
      "name": user.name,
      "email": user.email,
      "password": "*",
      "imgUrl": user.imgUrl,
      "bio": user.bio,
      "city": user.city,
      "phone": user.phone,
      "token": "",
      "roleID": user.roleID,
      "isVerify": user.isVerify
    };

    var userBody = json.encode(data);
    var response = await http.put(url, headers: authHeader, body: userBody);

    if(response.statusCode == 200) {
      var checkUser = User.fromJSON(json.decode(response.body));
      _user = checkUser;

      Session.user = response.body;

      return true;
    }

    return false; 
  } 

  // change the profile picture of logged user
  Future<String> changeUserImage(UploadUserImage uui, String oldImageName) async {
    Map<String, String> header = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    String time = DateTime.now().millisecondsSinceEpoch.toString();

    var data = {
      "username": uui.username,
      "imageName": time + "",
      "oldImageName": oldImageName,
      "imageData": uui.imageData.toString()
    };

    var response = await http.post(usersURL + "/" + _user.username + "/image", headers: header, body: json.encode(data));
    if(response.statusCode == 200) {
      _user.imgUrl = uui.username + time + ".png";

      Session.user = jsonEncode(_user.toJSON());

      return _user.imgUrl;
    }

    return "";
  }

  // DELETE
  // users have the ability to delete their accounts
  Future<bool> deleteUserAccount(String username) async {
    Map<String, String> authHeader = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    username = username.trim();

    var url = baseURL + "/" + username;

    var response = await http.delete(url, headers: authHeader);

    if(response.statusCode != 204)
      return false;

    return true;
  }

  // get the list of all users
  Future<List<User>> getUsers() async {
    Map<String, String> authHeader = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    var response = await http.get(usersURL, headers: authHeader);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<User> users = List<User>();

      for (var user in data) {
        users.add(User.fromJSON(user));
      }

      return users;
    }

    return null;
  }

  // get the list of all regular users
  Future<List<User>> getRegularUsers() async {
    Map<String, String> authHeader = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    var url = usersURL + "/regularUsers";
    var response = await http.get(url, headers: authHeader);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<User> users = List<User>();

      for (var user in data) {
        users.add(User.fromJSON(user));
      }

      return users;
    }

    return null;
  }

  Future<List<User>> getAllForVerification() async {
    Map<String, String> authHeader = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    var url = usersURL + "/forVerification";

    var response = await http.get(url, headers: authHeader);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<User> institutions = List<User>();

      for (var institution in data) {
        institutions.add(User.fromJSON(institution));
      }

      return institutions;
    }

    return null;
  }

  Future<List<User>> getAllVerifiedInstitutions() async {
    Map<String, String> authHeader = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    var url = usersURL + "/verifyInstitutions";

    var response = await http.get(url, headers: authHeader);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<User> institutions = List<User>();

      for (var institution in data) {
        institutions.add(User.fromJSON(institution));
      }

      return institutions;
    }

    return null;
  }

  // VERIFY
  Future<bool> verifyInstitution(String institutionUsername) async {
    Map<String, String> authHeader = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };

    var url = usersURL + "/verifyInstitution/" + this.username + "/" + institutionUsername;

    var response = await http.post(url, headers: authHeader);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}

// CHECK USER IMAGE
String checkUserImgUrl(String imgUrl){
  var url = imgUrl;
  if(!imgUrl.contains("http://") && !imgUrl.contains("https://"))
    url = getUserImageURL + url;
  return url;
}