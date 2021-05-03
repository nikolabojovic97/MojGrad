class PostComment{
  int _id;
  String _userName;
  int _postId;
  String _comment;
  DateTime _dateCreated;
  String userImgUrl = "";
  int _reportsNumber;

  PostComment(this._userName, this._postId, this._comment){
    this._dateCreated = DateTime.now();
  }

  int get id => _id;
  String get userName => _userName;
  int get postId => _postId;
  String get comment => _comment;
  DateTime get dateCreated => _dateCreated;
  int get reportsNumber => _reportsNumber;

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["userName"] = _userName;
    map["postId"] = _postId;
    map["comment"] = _comment;
    map["dateCreated"] = _dateCreated.toIso8601String();
    map["userImgUrl"] = userImgUrl;

    if(id != null)
      map["id"] = _id;
    
    return map;
  }

  PostComment.fromJSON(dynamic json){
    this._id = json["id"];
    this._userName = json["userName"];
    this._postId = json["postId"];
    this._comment = json["comment"];
    this._dateCreated = DateTime.parse(json["dateCreated"]);
    this.userImgUrl = json["userImgUrl"];
    this._reportsNumber = json["reportsNumber"];
  }
}