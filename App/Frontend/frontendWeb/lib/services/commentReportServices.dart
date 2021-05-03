import 'dart:convert';

import 'package:frontendWeb/models/commentReport.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';

class CommentReportServices {
  static String commentsReportsURL = commentReportURL;

  static Map<String, String> getHeader(token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    return header;
  }

  // GET
  // returns a list of all comment reports or all comment reports made by specific user
  static Future<List<CommentReport>> getCommentReports(String token) async {
    var header = getHeader(token);
    var url = commentsReportsURL;

    http.Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<CommentReport> reports = List<CommentReport>();

      for (var report in data) {
        reports.add(CommentReport.fromJSON(report));
      }

      return reports;
    }

    return null;
  }

  // returns one comment report specified by its ID
  static Future<CommentReport> getCommentReport(int id, String token) async {
    var header = getHeader(token);
    var url = commentsReportsURL + "/" + id.toString();

    var response = await http.get(url, headers: header);
    
    final Map parsed = json.decode(response.body);
    var report = CommentReport.fromJSON(parsed);

    return report;
  }

  // returns a list of all reports of one specific comment
  static Future<List<CommentReport>> getAllReportsOfComment(int commentID, String token) async {
    var header = getHeader(token);
    var url = commentsReportsURL + "/allCommentReports?commentID=" + commentID.toString();

    http.Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<CommentReport> reports = List<CommentReport>();

      for (var report in data) {
        reports.add(CommentReport.fromJSON(report));
      }

      return reports;
    }

    return null;
  }

  // ADD
  // a method that allows users to report some post
  static Future<bool> addCommentReport(CommentReport report, String token) async {
    var header = getHeader(token);

    var myReport = report.toJSON();
    var reportBody = json.encode(myReport);
    var res = await http.post(commentsReportsURL, headers: header, body: reportBody);
    
    return Future.value(res.statusCode == 201 || res.statusCode == 200 ? true : false);
  }

  // DELEYE
  // a method that allows users to undo previous report
  static Future<bool> deleteCommentReport(int id, String token) async {
    var header = getHeader(token);

    var url = commentsReportsURL + "/" + id.toString();
    var res = await http.delete(url, headers: header);

    return Future.value(res.statusCode == 204 ? true : false);
  }
}