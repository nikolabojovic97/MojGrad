import 'package:http/http.dart' as http;

class APIServices{
  static String komponentUrl = "http://10.0.2.2:49776/api/Books";

  static Future fetchComponent() async {
    return await http.get(komponentUrl);
  }
}