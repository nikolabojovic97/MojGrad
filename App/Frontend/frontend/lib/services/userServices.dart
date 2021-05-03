import 'dart:convert';
import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/models/uploadUserImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

String baseURL = usersURL;

class UserService with ChangeNotifier {
  User _user;
  String _username;
  String _token;
  DateTime _expiryDate;

  String get username{
    return _username;
  }

  User get user{
    return _user;
  }

  // returns the token if it's valid, or null if it isn't
  String get token {
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null)
      return _token;
    return null;
  }

  bool get isAuthorized {
    if(token != null)
      return true;
    return false;
  }

  static Map<String, String> header = {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };

  Future<bool> saveUserInMemory() async {
    final preferences = await SharedPreferences.getInstance();
    final data = json.encode(this._user.toJSON());

    return preferences.setString("user", data);
  }

  Future<User> getUserFromMemory() async {
    final preferences = await SharedPreferences.getInstance();
    var data = json.decode(preferences.getString("user"));

    return User.fromJSON(data);
  }

  Future<bool> removeUserFromMemory() async{
    final preferences = await SharedPreferences.getInstance();

    return preferences.remove("user");
  }

  Future<bool> setTokenExpiryDate() async {
    final preferences = await SharedPreferences.getInstance();
    final data = json.encode({"expirydate": this._expiryDate.add(new Duration(days: 7)).toIso8601String()});

    return preferences.setString("expiry", data);
  }

  // method that returns the token from Shared Preferences
  Future<String> getTokenExpiryDate() async {
    final preferences = await SharedPreferences.getInstance();

    return json.decode(preferences.getString("expiry"))["expirydate"];
  }

  Future<bool> removeTokenExpiryDate() async{
    final preferences = await SharedPreferences.getInstance();

    return preferences.remove("expiry");
  }

  // server will return json encoded version of User within response body in case of a successful login/signup (statusCode = 200)
  // in that case, we should update the token 
  bool checkResponseStatus(response) {
    if(response.statusCode == 200) {
      //var loggedUser = json.decode(response.body);

      _user = User.fromJSON(json.decode(response.body));
      _token = _user.token;
      _expiryDate = DateTime.now().add(Duration(days: 2));
      _username = _user.username;

      setTokenExpiryDate();
      notifyListeners();

      return true;
    }

    return null;//json.decode(response.body)["message"];
  }

  Response checkResponseStatusUser(Response response){
    if(response.statusCode == 200){
      _user = User.fromJSON(json.decode(response.body));
      _token = _user.token;
      _expiryDate = DateTime.now().add(Duration(days: 2));
      _username = _user.username;

      saveUserInMemory();
      setTokenExpiryDate();
      notifyListeners();
    }
    return response;
  }

  // auto login
  Future<bool> attemptAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();

    var tokenPref = preferences.containsKey("expiry");
    var userPref = preferences.containsKey("user");
    if(!tokenPref || !userPref)
      return false;

    final expiryDate = DateTime.parse(await getTokenExpiryDate());

    if(DateTime.now().isAfter(expiryDate))
      return false;

    _user = await getUserFromMemory();
    _token = _user.token;
    _expiryDate = expiryDate;

    notifyListeners();

    return true;
  } 

  Future<Response> attemptLogin(String username, String password) async {
    var url = baseURL + "/login";

    var response = await http.post(url, headers: header, body: json.encode({"username": username, "password": password}));
    print(url);
    print(response.body);

    // returns null if everything is okay or error message if something went wrong 
    return checkResponseStatusUser(response);
  }

  void logout(){
    _user = null;
    _username = null;
    _token = null;
    _expiryDate = null;

    removeUserFromMemory();
    removeTokenExpiryDate();
    
    notifyListeners();
  }

  Future<Response> attemptSignUp(User user) async {
    var data = {
      "username": user.username,
      "name": user.name,
      "email": user.email,
      "password": user.password,
      "imgUrl": user.imgUrl,
      "bio": user.bio,
      "city": user.city,
      "phone": user.phone,
      "token": user.token
    };

    var response = await http.post(usersURL, headers: header, body: json.encode(data));

    // returns null if everything is okay or error message if something went wrong 
    return response;
  }

  // we use this method to see someone's profile 
  Future<User> getUser(String username) async {
      Map<String, String> header = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
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

  // users can update information about their account, or change their password
  Future<bool> updateUserAccount(User user) async {
    Map<String, String> header = {
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
      "isVerify": user.isVerify, 
      "roleID": user.roleID
    };

    var userBody = json.encode(data);
    print(userBody);

    var response = await http.put(url, headers: header, body: userBody);

    return checkResponseStatus(response);
  } 

  // users have the ability to delete their accounts
  Future<bool> deleteUserAccount(String username) async {
    username = username.trim();

    var url = baseURL + "/" + username;

    var response = await http.delete(url, headers: header);

    if(response.statusCode != 204)
      return false;

    return true;
  }

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
    if(response.statusCode == 200)
      return uui.username + time + ".png";
    return "";
  }

  Future<List<User>> getAllVerifyInstitutions() async {
    Map<String, String> header = {
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
      'Authorization': 'Bearer ' + _user.token
    };
    var res = await http.get(usersURL + "/verifyInstitutions", headers: header);
    List<User> verifyinstitutions = [];

    if(res.statusCode == 200){
      var data = jsonDecode(res.body);

      for (var institution in data) {
        verifyinstitutions.add(User.fromJSON(institution));  
      }
    }
    return verifyinstitutions;
  }

  static Future<String> getPasswordRecovery(String username) async {
    var url = passwordRecoveryEmailURL + username;
    
    var response = await http.get(url, headers: header);
    
    return response.body.replaceAll('\"', '').trim();
  }
}

String checkUserImgUrl(String imgUrl){
  var url = imgUrl;
  if(!imgUrl.contains("http://") && !imgUrl.contains("https://"))
    url = getUserImageURL + url;
  return url;
}