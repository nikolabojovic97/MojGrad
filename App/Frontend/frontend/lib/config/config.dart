// server port

// final String port = ":45455";
final String port = ":2057";

// global URL
// final String baseURL = "http://192.168.8.109";
final String baseURL = "http://147.91.204.116";
final String url = baseURL + port + "/api/";

// URLs 
final String usersURL = url + "Users";
final String postsURL = url + "Posts";
final String commentsURL = url + "Comments";
final String postReportURL = url + "PostReport";
final String commentReportURL = url + "CommentReport";
final String postCommentURL = url + "PostComment";
final String postSolutionURL = url + "PostSolution";
final String statisticsURL = url + "Statistics";

final String postSolutionImageURL = baseURL + port + "/src/Solutions/";
final String addSolutionImageURL = baseURL + port + "/api/PostSolution/image";
final String getUserImageURL = baseURL + port + "/src/Users/";
final String sendUserImageURL = baseURL + port + "/api/src/Users/";
final String postImageURL = baseURL + port + "/src/Posts/";
final String addImageURL = baseURL + port + "/api/Posts/image";
final String defaultUserImage = "no-image.png";

//Password Recovery URLs
final String passwordRecoveryEmailURL = usersURL + "/password/recovery/";


// Google Maps API key
final String apiKey = "AIzaSyCYqyXvHMnNGT7ytcJ4H9RzQDsI1s8AA7E";

