class CommentReport {
  int _id;
  String _username;
  int _commentID;
  DateTime _dateReported;
  int _reportStatus;

  CommentReport(this._username, this._commentID) {
    _dateReported = DateTime.now();
    _reportStatus = 0;
  }

  int get id => _id;
  String get username => _username;
  int get commentID => _commentID;
  DateTime get dateReported => _dateReported;
  int get reportStatus => _reportStatus;

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    if(id != null)
      map["id"] = _id;

    map["username"] = _username;
    map["commentId"] = _commentID;
    map["dateReported"] = _dateReported.toIso8601String();
    map["reportStatus"] = _reportStatus;

    return map;
  }

  CommentReport.fromJSON(Map<String, dynamic> json) {
    this._id = json["id"];
    this._username = json["username"];
    this._commentID = json["commentId"];
    this._dateReported = DateTime.parse(json["dateReported"]);
    this._reportStatus = json["reportStatus"];
  }
}