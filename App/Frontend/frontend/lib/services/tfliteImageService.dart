import 'dart:convert';
import 'dart:io';

import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/enums.dart';
import 'package:Frontend/models/imagePredictionResult.dart';
import 'package:Frontend/models/postProblemType.dart';
import 'package:tflite/tflite.dart';
import 'package:http/http.dart' as http;

class TFLiteImageService{
  static List<ImagePredictionResult> _output = List();
  static var modelLoaded = false;

  /*
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };*/

  static Map<String, String> getHeader(String token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
      'Bearer ' + token
    };
    return header;
  }

  static Future loadModel() async{
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",);
  }

  static Future<ImagePredictionResult> classifyImage(String path) async {
    _output.clear();
    var list = await Tflite.runModelOnImage(path: path);
    for(var element in list){
      _output.add(ImagePredictionResult(element['index'], element['label'], element['confidence']));
      print("[CLASSIFY RESULT]: ${element['index']}, ${element['label']}, ${element['confidence']}");
    }

    _output.sort((a, b) => a.confidence.compareTo(b.confidence));
    return _output.first.confidence >= 0.95 ? _output.first : ImagePredictionResult(ProblemType.neidentifikovano.index, ProblemType.neidentifikovano.toString(), 1.0);
  }

  static Future<bool> addResult(PostProblemType type, String token) async {
    var header = getHeader(token);
    var typeMap = {
        "id": 0,
        "postId": type.postId,
        "problemType": type.problemType,
      };
    var data = json.encode(typeMap);
    var result = await http.post(statisticsURL, headers: header, body: data);
    print(result.body);
    return result.statusCode == 204 ? true : false;
  }

  static void dispose(){
    Tflite.close();
  }
}