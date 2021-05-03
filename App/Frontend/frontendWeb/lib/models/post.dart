class Post {
  int _id;
  String _userName;
  String _description;
  List<String> _imageUrls;
  int leafNumber;
  String _institutionUserName;
  bool isLiked = false;
  bool _isSolved = false;
  bool _isSolution = false;
  String _location;
  String _latLng;
  String _address;
  DateTime _dateCreated;
  DateTime _lastTimeModify;
  String _userImageUrl = "";
  int _reportsNumber;
  int commentsNumber;

  Post(this._userName, this._description, this._location, this._latLng, this._address) {
    this._dateCreated = DateTime.now();
    this._lastTimeModify = DateTime.now();
    this.leafNumber = 0;
  }

  int get id => _id;
  String get userName => _userName;
  String get description => _description;
  List<String> get imgUrl => _imageUrls;
  bool get isSolved => _isSolved;
  bool get isSolution => _isSolution;
  String get location => _location;
  String get latLng => _latLng;
  String get address => _address;
  DateTime get dateCreated => _dateCreated;
  DateTime get lastTimeModify => _lastTimeModify;
  String get userImageUrl => _userImageUrl;
  String get institutionUserName => _institutionUserName;
  int get reportsNumber => _reportsNumber;

  String dateCreatedToString(){
    return _dateCreated.day.toString() + "/" + _dateCreated.month.toString() + "/" + _dateCreated.year.toString(); 
  }

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["userName"] = _userName;
    map["description"] = _description;
    map["imgUrl"] = _imageUrls;
    map["leafNumber"] = leafNumber;
    map["isLiked"] = isLiked;
    map["isSolved"] = _isSolved;
    map["isSolution"] = _isSolution;
    map["location"] = _location;
    map["latLng"] = _latLng;
    map["address"] = _address;
    map["dateCreated"] = _dateCreated.toIso8601String();
    map["lastTimeModify"] = _lastTimeModify.toIso8601String();
    map["userImageUrl"] = _userImageUrl;
    map["institutionUserName"] = institutionUserName;

    if(id != null)
      map["id"] = _id;
    return map;
  }

  Post.fromJSON(Map<String, dynamic> json) {
    this._id = json["id"];
    this._userName = json["userName"];
    this._description = json["description"];
    if (json["imgUrl"] != null)
      this._imageUrls = json["imgUrl"].cast<String>().toList();
    this.leafNumber = json["leafNumber"];
    this.isLiked = json["isLiked"];
    this._isSolved = json["isSolved"];
    this._isSolution = json["isSolution"];
    this._location = json["location"];
    this._latLng = json["latLng"];
    this._address = json["address"];
    this._dateCreated = DateTime.parse(json["dateCreated"]);
    this._lastTimeModify = DateTime.parse(json["lastTimeModify"]);
    this._userImageUrl = json["userImageUrl"];
    this._institutionUserName = json["institutionUserName"];
    this._reportsNumber = json["reportsNumber"];
    this.commentsNumber = json["commentsNumber"];
  }
}