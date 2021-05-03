import 'dart:convert';

import 'package:frontendWeb/config/config.dart';
import 'package:frontendWeb/models/statistics.dart';
import 'package:http/http.dart' as http;

class StatisticsServices {
  static Map<String, String> getHeader(token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token
    };
    return header;
  }

  // GET
  static Future<Statistics> getStatistics(String token) async {
    var header = getHeader(token);
    final response = await http.get(statisticsURL, headers: header);

    if (response.statusCode != 200) 
      return null;

    final Map parsed = json.decode(response.body);
    return Statistics.fromJSON(parsed);
  }
}