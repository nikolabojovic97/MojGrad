class Statistics {
  int _userNumber;
  int _solutionNumber;
  int _postNumber;
  int _reactionNumber;
  int _commentNumber;
  int _reportNumber;
  int _latestPostNumber;
  int _latestReactionNumber;
  int _latestCommentNumber;
  int _latestReportNumber;
  List<double> _dailyPosts;
  List<double> _dailyLikes;
  List<double> _problemTypes;

  int get userNumber => _userNumber;
  int get solutionNumber => _solutionNumber;
  int get postNumber => _postNumber;
  int get reactionNumber => _reactionNumber;
  int get commentNumber => _commentNumber;
  int get reportNumber => _reportNumber;
  int get latestPostNumber => _latestPostNumber;
  int get latestReactionNumber => _latestReactionNumber;
  int get latestCommentNumber => _latestCommentNumber;
  int get latestReportNumber => _latestReportNumber;
  List<double> get dailyPosts => _dailyPosts;
  List<double> get dailyLikes => _dailyLikes;
  List<double> get problemTypes => _problemTypes;

  double getPostProgress() {
    return ((_latestPostNumber / _postNumber) * 100).floorToDouble();
  }

  double getReactionProgress() {
    return ((_latestReactionNumber / _reactionNumber) * 100).floorToDouble();
  }

  Statistics.fromJSON(Map<String, dynamic> json) {
    this._userNumber = json["userNumber"];
    this._solutionNumber = json["solutionNumber"];
    this._postNumber = json["postNumber"];
    this._reactionNumber = json["reactionNumber"];
    this._commentNumber = json["commentNumber"];
    this._reportNumber = json["reportNumber"];
    this._latestPostNumber = json["latestPostNumber"];
    this._latestReactionNumber = json["latestReactionNumber"];
    this._latestCommentNumber = json["latestCommentNumber"];
    this._latestReportNumber = json["latestReportNumber"];
    this._dailyPosts = json["dailyPosts"].cast<double>();
    this._dailyLikes = json["dailyLikes"].cast<double>();
    this._problemTypes = json["problemTypes"].cast<double>();
  }
}