import 'dart:convert';

import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/postReport.dart';
import 'package:http/http.dart' as http;

class PostReportServices {
  static String postReportsURL = postReportURL;

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
  static Future<bool> reportPost(PostReport report, String token) async {
    var header = getHeader(token);
    var myReport = report.toJSON();
    var reportBody = json.encode(myReport);
    var res = await http.post(postReportsURL, headers: header, body: reportBody);

    return Future.value(res.statusCode == 200 || res.statusCode == 201 ? true : false);
  }

  // a method that allows users to undo previous report
  static Future<bool> deletePostReport(int id, String token) async {
    var header = getHeader(token);
    var url = postReportsURL + "/" + id.toString();
    var res = await http.delete(url, headers: header);

    return Future.value(res.statusCode == 204 ? true : false);
  }
}
