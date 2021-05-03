class PostReport {
  int _id;
  String _username;
  int _postID;
  DateTime _dateReported;
  String _reporterImgUrl;
  String _reportedUsername;
  int _reportsNumber;
  int _reportStatus;
  double _reportValidity;

  bool selected = false;

  PostReport(this._username, this._postID) {
    _dateReported = DateTime.now();
    _reportStatus = 0;
  }

  int get id => _id;
  String get username => _username;
  int get postID => _postID;
  DateTime get dateReported => _dateReported;
  String get reporterImgUrl => _reporterImgUrl;
  String get reportedUsername => _reportedUsername;
  int get reportsNumber => _reportsNumber;
  int get reportStatus => _reportStatus;
  double get reportValidity => _reportValidity;

  String dateReportedToString(){
    return _dateReported.day.toString() + "/" + _dateReported.month.toString() + "/" + _dateReported.year.toString(); 
  }

  double reportValidityRounded() {
    return _reportValidity.roundToDouble();
  }

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    if(id != null)
      map["id"] = _id;

    map["userName"] = _username;
    map["postId"] = _postID;
    map["dateReported"] = _dateReported.toIso8601String();
    map["reportStatus"] = _reportStatus;
 
    return map;
  }

  PostReport.fromJSON(dynamic json) {
    this._id = json["id"];
    this._username = json["userName"];
    this._postID = json["postId"];
    this._dateReported = DateTime.parse(json["dateReported"]);
    this._reporterImgUrl = json["reporterImgUrl"];
    this._reportedUsername = json["reportedUserName"];
    this._reportsNumber = json["reportsNumber"];
    this._reportStatus = json["reportStatus"];
    this._reportValidity = json["reportValidity"];
  }
}