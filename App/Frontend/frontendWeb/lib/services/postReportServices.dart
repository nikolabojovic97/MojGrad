import 'dart:convert';

import 'package:frontendWeb/models/postReport.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';

class PostReportServices {
  static String postReportsURL = postReportURL;

  static Map<String, String> getHeader(token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    return header;
  }

  // GET
  // returns a list of all post reports or all post reports made by specific user
  static Future<List<PostReport>> getPostReports(String token) async {
    var header = getHeader(token);

    var url = postReportsURL;

    http.Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<PostReport> reports = List<PostReport>();

      for (var report in data) {
        reports.add(PostReport.fromJSON(report));
      }

      return reports;
    }

    return null;
  }

  // returns a list of all reports of one specific post
  static Future<List<PostReport>> getAllReportsOfPost(int postID, String token) async {
    var header = getHeader(token);
    var url = postReportsURL + "/allPostReports?postID=" + postID.toString();

    http.Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<PostReport> reports = List<PostReport>();

      for (var report in data) {
        reports.add(PostReport.fromJSON(report));
      }

      return reports;
    }

    return null;
  }

  // returns one post report specified by its ID
  static Future<PostReport> getPostReport(int id, String token) async {
    var header = getHeader(token);
    var url = postReportsURL + "/" + id.toString();

    var response = await http.get(url, headers: header);
    
    final Map parsed = json.decode(response.body);
    var report = PostReport.fromJSON(parsed);

    return report;
  }

  // ADD
  // a method that allows users to report some post
  static Future<bool> addPostReport(PostReport report, String token) async {
    var header = getHeader(token);

    var myReport = report.toJSON();
    var reportBody = json.encode(myReport);
    var res = await http.post(postReportsURL, headers: header, body: reportBody);
    print(res.statusCode);

    return Future.value(res.statusCode == 200 || res.statusCode == 201 ? true : false);
  }

  // DELETE
  // a method that allows users to undo previous report
  static Future<bool> deletePostReport(int id, String token) async {
    var header = getHeader(token);
    var url = postReportsURL + "/" + id.toString();
    var res = await http.delete(url, headers: header);

    return Future.value(res.statusCode == 204 ? true : false);
  } 
}