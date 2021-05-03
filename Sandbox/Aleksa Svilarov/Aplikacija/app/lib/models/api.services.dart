import 'package:http/http.dart' as http;

class APIServices{
  static String url = "http://192.168.8.100:45455/RHCP";

  static Future fetchUser() async{
    return await http.get(url);
  }

}