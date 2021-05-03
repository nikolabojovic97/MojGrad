class User{
  int id;
  String username;
  String password;
  String ime;
  String prezime;

  User({this.username, this.password, this.ime, this.prezime});
  //User.WithId({this.id, this.username, this.password, this.ime, this.prezime});

  /*int get _id => id;
  String get _username => username;
  String get _password => password;
  String get _ime => ime;
  String get _prezime => prezime;*/

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      username: json['username'],
      password: json['password'],
      ime: json['ime'],
      prezime: json['prezime']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    map["ime"] = ime;
    map["prezime"] = prezime;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  User.fromObject(dynamic o){
    this.id = o["id"];
    this.username = o["username"];
    this.password = o["password"];
    this.ime = o["ime"];
    this.prezime = o["prezime"];
  }

}