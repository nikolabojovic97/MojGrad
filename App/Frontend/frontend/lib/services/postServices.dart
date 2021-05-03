import 'dart:convert';
import 'dart:async';

import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/postLike.dart';
import 'package:Frontend/models/PostSolution.dart';
import 'package:http/http.dart' as http;
import '../models/uploadPostImage.dart';
import '../models/post.dart';

class PostServices {
  static String postURL = postsURL;
  static String imageURL = addImageURL;

  static Map<String, String> getHeader(String token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
      'Bearer ' + token
    };
    return header;
  }

  static Future<List<Post>> getPosts(String token) async {
    var header = getHeader(token);
    http.Response response = await http.get(postURL, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Post> posts = List<Post>();

      for (var post in data) {
        posts.add(Post.fromJSON(post));
      }

      return posts;
    }
    return null;
  }

  static Future<List<Post>> getPostsForUser(String userName, String token) async {
    var header = getHeader(token);
    http.Response response = await http.get(postURL + "/forUser?userName=" + userName, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Post> posts = List<Post>();

      for (var post in data) {
        posts.add(Post.fromJSON(post));
      }

      return posts;
    }
    return null;
  }

  static Future<bool> addPostImage(UploadPostImage postImage, String token) async {
    var header = getHeader(token);
    var myImage = postImage.toJSON();
    var imageBody = json.encode(myImage);

    var res = await http.post(addImageURL, headers: header, body: imageBody);
    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<Post> addPost(Post post, String token) async {
    var header = getHeader(token);
    var myPost = post.toJSON();
    var postBody = json.encode(myPost);
    var res = await http.post(postURL, headers: header, body: postBody);

    Post newPost;
    if (res.statusCode == 201) {
      newPost = Post.fromJSON(json.decode(res.body));
    }
    return Future.value(res.statusCode == 201 ? newPost : null);
  }

  static Future<bool> addPostLike(PostLike postLike, String token) async {
    var header = getHeader(token);
    var newLike = postLike.toJSON();
    var likeBody = json.encode(newLike);
    var res = await http.post(postURL + "/like", headers: header, body: likeBody);

    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<bool> addSolutionOnProblem(PostSolution postSolution, String token) async {
    var header = getHeader(token);
    var newSolution = postSolution.toJSON();
    var solutionBody = json.encode(newSolution);
    var res = await http.post(postURL + "/solution", headers: header, body: solutionBody);

    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<bool> deletePostLike(PostLike postLike, String token) async {
    var header = getHeader(token);
    var newLike = postLike.toJSON();
    var likeBody = json.encode(newLike);
    print(likeBody);
    var res = await http.post(postURL + "/deleteLike", headers: header, body: likeBody);

    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<bool> checkPostLikeStatus(PostLike postLike, String token) async {
    var header = getHeader(token);
    var like = postLike.toJSON();
    var likeBody = json.encode(like);
    var res = await http.post(postURL + "/likeStatus", headers: header, body: likeBody);

    return Future.value(res.statusCode == 200 ? true : false);
  }

  static Future<Post> getPost(String userName, String token) async {
    var header = getHeader(token);
    userName = userName.trim();

    var res = await http.get(postURL + "/" + userName, headers: header);

    print(res.body);

    final Map parsed = json.decode(res.body);
    return Post.fromJSON(parsed);
  }

  static Future<Post> getPostById(int id, String token) async {
    var header = getHeader(token);
    var res = await http.get(postURL + "/" + id.toString(), headers: header);
    final Map parsed = json.decode(res.body);
    return Post.fromJSON(parsed);
  }

  static Future<bool> updatePost(int id, Post post, String token) async {
    var header = getHeader(token);
    var newPost = post.toJSON();
    var newPostBody = json.encode(newPost);

    var res = await http.put(postURL + "/" + id.toString(), headers: header, body: newPostBody);

    return Future.value(res.statusCode == 204 ? true : false);
  }

  static Future<bool> deletePost(int id, String token) async {
    var header = getHeader(token);
    var res = await http.delete(postURL + "/" + id.toString(), headers: header);
    return Future.value(res.statusCode == 204 ? true : false);
  }

  static Future<List<Post>> getSortedPosts(SortType type, String token, {int number = 0}) async {
    var header = getHeader(token);
    var url = postURL + "/sort/${type.index}?number=$number";

    http.Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Post> posts = List<Post>();

      for (var post in data) {
        posts.add(Post.fromJSON(post));
      }

      return posts;
    }
    return null;
  }

  static Future<List<Post>> getSearchedPosts(String value, String username, String token) async {
    var header = getHeader(token);
    var url = postURL + "/search/$value/$username";

    http.Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Post> posts = List<Post>();

      for (var post in data) posts.add(Post.fromJSON(post));

      return posts;
    }
    return null;
  }

  // QUICK SORT - if an app doesn't need to send a request to server
  static List<Post> sortPosts(List<Post> posts, SortType type) {
    if (posts.length == 0) return null;

    if (type == SortType.dates_asc)
      posts.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
    else if (type == SortType.dates_desc)
      posts.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    else if (type == SortType.leaves_asc)
      posts.sort((a, b) => a.leafNumber.compareTo(b.leafNumber));
    else if (type == SortType.leaves_desc)
      posts.sort((a, b) => b.leafNumber.compareTo(a.leafNumber));
    else if (type == SortType.comments_asc)
      posts.sort(
          (a, b) => a.postComments.length.compareTo(b.postComments.length));
    else if (type == SortType.comments_desc)
      posts.sort(
          (a, b) => b.postComments.length.compareTo(a.postComments.length));

    return posts;
  }

  static List<Post> postsByUser(List<Post> posts, String username) {
    List<Post> _newList = List<Post>();
    for (var post in posts) {
      if (post.userName == username) _newList.add(post);
    }
    return _newList;
  }

  static Future<Post> getPostProblemBySolutionId(String userName, int solutionId, String token) async {
    var header = getHeader(token);
    var res = await http.get(postURL + "/" + userName + "/" + solutionId.toString(), headers: header);
    final Map parsed = json.decode(res.body);
    return Post.fromJSON(parsed);
  }
}
