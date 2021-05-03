class BandMember{
  int _id;
  int _bandID;
  String _firstName;
  String _lastName;
  
  // constructors
  BandMember(this._bandID, this._firstName, this._lastName);

  // getters
  int get id => _id;
  int get bandID => _bandID;
  String get firstName => _firstName;
  String get lastName => _lastName;

  // setters
  set bandID(int newBandID) {
    _bandID = newBandID;
  }
  set firstName(String newFirstName) {
    _firstName = newFirstName;
  }
  set lastName(String newLastName) {
    _lastName = newLastName;
  }

  // konvertuje objekat u JSON string
  // kasnije se podaci preko JSON-a salju u API
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["bandID"] = _bandID;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;

    if(_id != null)
      map["id"] = _id;

    return map;
  }

  // popunjava vrednosti koje dobija iz JSON objekta (stringa)
  BandMember.fromJSON(dynamic json) {
    this._id = json["id"];
    this._bandID = json["bandID"];
    this._firstName = json["firstName"];
    this._lastName = json["lastName"];
  }
}