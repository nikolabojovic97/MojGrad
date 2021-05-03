class PostReport {
  int _id;
  String _username;
  int _postID;
  DateTime _dateReported;
  int _reportStatus;

  PostReport(this._username, this._postID) {
    _dateReported = DateTime.now();
    _reportStatus = 0;
  }

  int get id => _id;
  String get username => _username;
  int get postID => _postID;
  DateTime get dateReported => _dateReported;
  int get reportStatus => _reportStatus;

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    if(id != null)
      map["id"] = _id;

    map["username"] = _username;
    map["postId"] = _postID;
    map["dateReported"] = _dateReported.toIso8601String();
    map["reportStatus"] = _reportStatus;

    return map;
  }

  PostReport.fromJSON(Map<String, dynamic> json) {
    this._id = json["id"];
    this._username = json["username"];
    this._postID = json["postId"];
    this._dateReported = DateTime.parse(json["dateReported"]);
    this._reportStatus = json["reportStatus"];
  }
}