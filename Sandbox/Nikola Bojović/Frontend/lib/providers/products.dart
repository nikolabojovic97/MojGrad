import 'dart:io';
import 'package:http/http.dart' as http;

String baseProductURL = "http://127.0.0.1:44332/Product/";

class ProductsProvider{


  Future getAllProducts(String token) async {
    return await http.get(baseProductURL, headers: { "Authorization": "Bearer " + token});
  }
}