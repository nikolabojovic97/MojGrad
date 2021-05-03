import 'dart:convert';

import 'package:Frontend/config/config.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/postComment.dart';

class PostCommentServices {
  static String commentURL = postCommentURL;

  static Map<String, String> getHeader(String token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
      'Bearer ' + token
    };
    return header;
  }

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
    http.Response response =
        await http.get(commentURL + "/" + id.toString(), headers: header);

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);

      final Map parsed = json.decode(res.body);
      return PostComment.fromJSON(parsed);
    }
    return null;
  }

  static Future<List<PostComment>> getPostCommentsByUserName(String userName, String token) async {
    var header = getHeader(token);
    http.Response response =
        await http.get(commentURL + "?username=" + userName, headers: header);

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
}
