class PostLike{
  int _postId;
  String _userName;
  DateTime _time;

  PostLike(this._postId, this._userName){
    this._time = DateTime.now();
  }

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["postId"] = _postId;
    map["userName"] = _userName;
    map["time"] = _time.toIso8601String();

    return map;
  }
}