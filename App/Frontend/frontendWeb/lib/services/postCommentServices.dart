import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../models/postComment.dart';

class PostCommentServices {
  static String commentURL = postCommentURL;

  static Map<String, String> getHeader(token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    return header;
  }

  // GET
  static Future<List<PostComment>> getPostComments(int postId, String token) async {
    var header = getHeader(token);

    http.Response response = await http.get(commentURL + "/postId/" + postId.toString(), headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<PostComment> comments = List<PostComment>();

      for (var comment in data) {
        comments.add(PostComment.fromJSON(comment));
      }

      return comments;
    }
    return null;
  }

  static Future<PostComment> getPostCommentById(int id, String token) async {
    var header = getHeader(token);

    var url = postCommentURL + "/" + id.toString();

    var response = await http.get(url, headers: header);

    final Map parsed = json.decode(response.body);
    var postComment = PostComment.fromJSON(parsed);

    return postComment;
  }

  static Future<List<PostComment>> getPostCommentsByUserName(String userName, String token) async {
    var header = getHeader(token);

    http.Response response = await http.get(commentURL + "?username=" + userName, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<PostComment> comments = List<PostComment>();

      for (var comment in data) {
        comments.add(PostComment.fromJSON(comment));
      }

      return comments;
    }
    return null;
  }

  // ADD
  static Future<PostComment> addPostComment(PostComment postComment, String token) async {
    var header = getHeader(token);

    var myPostComment = postComment.toJSON();
    var postCommentBody = json.encode(myPostComment);
    var res = await http.post(commentURL, headers: header, body: postCommentBody);
    
    var newPostComment = PostComment.fromJSON(jsonDecode(res.body));

    return Future.value(res.statusCode == 201 ? newPostComment : null);
  }

  static Future<bool> deletePostComment(int id, String token) async {
    var header = getHeader(token);
    var res = await http.delete(commentURL + "/" + id.toString(), headers: header);
    return Future.value(res.statusCode == 204 ? true : false);
  }

  // DELETE
  static Future<bool> deleteCommentAndApproveReports(int id, String token) async {
    var header = getHeader(token);
    var url = commentURL + "/deleteAndApproveReports/?id=" + id.toString();
    var res = await http.delete(url, headers: header);
    return Future.value(res.statusCode == 204 ? true : false);
  }

  static Future<bool> deleteAllReportsOfComment(int id, String token) async {
    var header = getHeader(token);
    var url = commentURL + "/deleteAllReports/?id=" + id.toString();
    var res = await http.delete(url, headers: header);
    return Future.value(res.statusCode == 204 ? true : false);
  }
}
