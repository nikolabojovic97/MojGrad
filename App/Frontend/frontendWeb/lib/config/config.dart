// server port
// final String port = ":64018";
final String port = ":2057";

// global URL
// final String url = "http://127.0.0.1" + port + "/api/";
// final String baseURL = "http://127.0.0.1";
final String url = "http://147.91.204.116" + port + "/api/";
final String baseURL = "http://147.91.204.116";

// URLs 
final String usersURL = url + "Users";
final String postsURL = url + "Posts";
final String postReportURL = url + "PostReport";
final String commentReportURL = url + "CommentReport";
final String postCommentURL = url + "PostComment";
final String statisticsURL = url + "Statistics";

final String getUserImageURL = baseURL + port + "/src/Users/";
final String getPostImageURL = baseURL + port + "/src/Posts/";
final String addImageURL = baseURL + port + "/api/Posts/image";
final String defaultUserImage = "no-image.png";
final String defaultInstitutionImage = "no-image-institution.png";

//Password Recovery URLs
final String passwordRecoveryEmailURL = usersURL + "/password/recovery/";