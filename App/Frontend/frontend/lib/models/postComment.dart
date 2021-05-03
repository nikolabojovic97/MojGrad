class PostComment{
  int _id;
  String _userName;
  int _postId;
  String _comment;
  DateTime _dateCreated;
  String _userImgUrl = "";

  PostComment(this._userName, this._postId, this._comment){
    this._dateCreated = DateTime.now();
  }

  int get id => _id;
  String get userName => _userName;
  int get postId => _postId;
  String get comment => _comment;
  DateTime get dateCreated => _dateCreated;
  String get userImgUrl => _userImgUrl;

  set userImgUrl(String userImgUrl){
    _userImgUrl = userImgUrl;
  }

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["userName"] = _userName;
    map["postId"] = _postId;
    map["comment"] = _comment;
    map["dateCreated"] = _dateCreated.toIso8601String();
    map["userImgUrl"] = _userImgUrl;

    if(id != null)
      map["id"] = _id;
    
    return map;
  }

  PostComment.fromJSON(Map<String, dynamic> json){
    this._id = json["id"];
    this._userName = json["userName"];
    this._postId = json["postId"];
    this._comment = json["comment"];
    this._dateCreated = DateTime.parse(json["dateCreated"]);
    this._userImgUrl = json["userImgUrl"];
  }

}