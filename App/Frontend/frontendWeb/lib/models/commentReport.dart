class CommentReport {
  int _id;
  String _username;
  int _commentID;
  DateTime _dateReported;
  String _reporterImgUrl;
  String _reportedUserName;
  int _postID;
  int _reportsNumber;
  int _reportStatus;
  double _reportValidity;

  bool selected = false;

  CommentReport(this._username, this._commentID) {
    _dateReported = DateTime.now();
    _reportStatus = 0;
  }

  int get id => _id;
  String get username => _username;
  int get commentID => _commentID;
  DateTime get dateReported => _dateReported;
  String get reporterImgUrl => _reporterImgUrl;
  String get reportedUserName => _reportedUserName;
  int get postId => _postID;
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
    map["commentId"] = _commentID;
    map["dateReported"] = _dateReported.toIso8601String();
    map["reportStatus"] = _reportStatus;

    return map;
  }

  CommentReport.fromJSON(dynamic json) {
    this._id = json["id"];
    this._username = json["userName"];
    this._commentID = json["commentId"];
    this._dateReported = DateTime.parse(json["dateReported"]);
    this._reporterImgUrl = json["reporterImgUrl"];
    this._reportedUserName = json["reportedUserName"];
    this._postID = json["postId"];
    this._reportsNumber = json["reportsNumber"];
    this._reportStatus = json["reportStatus"];
    this._reportValidity = json["reportValidity"];
  }
}