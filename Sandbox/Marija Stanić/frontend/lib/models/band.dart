class Band {
  int _id;
  String _email;
  String _password;
  String _name;

  // constructors
  Band(this._email, this._password, this._name);

  // getters
  int get id => _id;
  String get email => _email;
  String get password => _password;
  String get name => _name;

  // setters
  set email(String newEmail) {
    _email = newEmail;
  }
  set password(String newPassword) {
    _password = newPassword;
  }
  set name(String newName) {
    _name = newName;
  }

  // konvertuje objekat u JSON string
  // kasnije se podaci preko JSON-a salju u API
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    
    map["email"] = _email;
    map["password"] = _password;
    map["name"] = _name;

    if(_id != null)
      map["id"] = _id;

    return map;
  }

  // konvertuje JSON string u objekat
  Band.fromJSON(dynamic json) {
    this._id = json["id"];
    this._email = json["email"];
    this._password = json["password"];
    this._name = json["name"];
  }
}