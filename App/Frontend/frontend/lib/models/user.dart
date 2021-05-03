class User {
  String username;
  String name;
  String email;
  String password = "";
  String imgUrl;
  String bio;
  String city;
  String phone;
  String token;
  int roleID = 0;
  bool isVerify = false;
  bool isVerifyInstitution;

  User(this.username, this.name, this.email, this.password, this.imgUrl, this.bio, this.city, this.phone, this.token);

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["username"] = this.username;
    map["name"] = this.name;
    map["email"] = this.email;
    map["password"] = "";
    map["imgUrl"] = this.imgUrl;
    map["bio"] = this.bio;
    map["city"] = this.city;
    map["phone"] = this.phone;
    map["token"] = this.token;
    map["roleID"] = this.roleID;
    map["isVerify"] = this.isVerify;
    map["isVerifyInstitution"] = this.isVerifyInstitution;
    
    return map;
  }

  User.fromJSON(dynamic json){
    this.username = json["username"];
    this.name = json["name"];
    this.email = json["email"];
    this.password = json["password"]; // this will always be an empty string
    this.imgUrl = json["imgUrl"];
    this.bio = json["bio"];
    this.city = json["city"];
    this.phone = json["phone"];
    this.token = json["token"];
    this.roleID = json["roleID"];
    this.isVerify = json["isVerify"];
    this.isVerifyInstitution = json["isVerifyInstitution"];
  }
}