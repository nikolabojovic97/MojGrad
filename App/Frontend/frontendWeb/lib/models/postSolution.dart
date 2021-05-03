class PostSolution {
  int _id;
  int _postProblemId;
  int _postSolutionId;
  
  PostSolution(this._postProblemId, this._postSolutionId,);

  int get id => _id;
  int get postProblemId => _postProblemId;
  int get postSolutionId => _postSolutionId;
  
  Map<String, dynamic> toJSON(){
    var map = Map<String, dynamic>();

    map["postProblemId"] = _postProblemId;
    map["postSolutionId"] = _postSolutionId;

    if(id != null)
      map["id"] = _id;
      
    return map;
  }

  PostSolution.fromJSON(Map<String, dynamic> json) {
    this._id = json["id"];
    this._postProblemId = json["postProblemId"];
    this._postSolutionId = json["postSolutionId"];
  }
}