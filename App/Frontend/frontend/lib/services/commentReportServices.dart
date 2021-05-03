import 'dart:convert';

import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/commentReport.dart';
import 'package:http/http.dart' as http;

class CommentReportServices {
  static String commentsReportsURL = commentReportURL;

  static Map<String, String> getHeader(String token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
      'Bearer ' + token
    };
    return header;
  }
  // a method that allows users to report some post
  static Future<bool> reportComment(CommentReport report, String token) async {
    var header = getHeader(token);
    var myReport = report.toJSON();
    var reportBody = json.encode(myReport);
    var res = await http.post(commentsReportsURL, headers: header, body: reportBody);
    
    return Future.value(res.statusCode == 201 || res.statusCode == 200 ? true : false);
  }

  // a method that allows users to undo previous report
  static Future<bool> deleteCommentReport(int id, String token) async {
    var header = getHeader(token);
    var url = commentsReportsURL + "/" + id.toString();
    var res = await http.delete(url, headers: header);

    return Future.value(res.statusCode == 204 ? true : false);
  }
}