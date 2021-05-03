import 'package:Frontend/models/enums.dart';

class PostProblemType {
  int id;
  int postId;
  int problemType;

  PostProblemType(this.postId, this.problemType);

  PostProblemType.fromJSON(Map<String, dynamic> json){
    this.id = json["id"];
    this.postId = json["postId"];
    this.problemType = json["problemType"];
  }

  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["postId"] = postId;
    map["problemType"] = problemType;
    return map;
  }
}