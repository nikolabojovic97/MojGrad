import 'package:universal_html/prefer_universal/html.dart';

class Session {
  static set user(String user) => user == null ? window.sessionStorage.remove("user") : window.sessionStorage["user"] = user;
  static String get user => window.sessionStorage["user"];
}