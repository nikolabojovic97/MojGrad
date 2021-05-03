class UploadUserImage {
  String username;
  String imageData;

  UploadUserImage(this.username, this.imageData);

  Map<String, dynamic> toJSON() {
    var map = Map<String, dynamic>();

    map["username"] = this.username;
    map["imageData"] = this.imageData;

    return map;
  }
}