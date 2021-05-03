class UploadPostImage{
  String _imageName;
  int _postId;
  List<String> _imageData;

  UploadPostImage(this._postId,this._imageName, this._imageData);

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["postId"] = _postId;
    map["imageName"] = _imageName;
    map["imageData"] = _imageData;

    return map;
  }
}