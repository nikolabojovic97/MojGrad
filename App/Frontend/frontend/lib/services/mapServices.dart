import 'dart:convert';

import 'package:Frontend/config/config.dart';
import 'package:Frontend/utils/cyrillicConverter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapServices {
  static Location _location = Location();

  static Future<bool> requestService() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if(!serviceEnabled){
      serviceEnabled = await _location.requestService();
      if(!serviceEnabled)
        return false;
    }
    return true;
  }

  static Future<bool> requestPermission() async {
    PermissionStatus permissionGranted = await _location.hasPermission();
    if(permissionGranted != PermissionStatus.granted){
      permissionGranted = await _location.requestPermission();
      if(permissionGranted != PermissionStatus.granted)
        return false;
    }  
    return true;
  }

  static Future<LatLng> getDeviceLocation() async {
    bool service = await requestService();
    if(!service)
      return null;

    bool permission = await requestPermission();
    if(!permission)
      return null;

    var locationData = await _location.getLocation();
    return LatLng(locationData.latitude, locationData.longitude);
  }

  static Future<Address> getAdress(LatLng location) async {
    return (await Geocoder.google(apiKey).findAddressesFromCoordinates(Coordinates(location.latitude, location.longitude))).first;
  }

  static Future<LatLng> getCityLatLng(String city) async {
    var response = await http.get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$city&inputtype=textquery&fields=geometry&key=$apiKey");
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);

      double lat = (data["candidates"][0]["geometry"]["location"]["lat"]);
      double lng = data["candidates"][0]["geometry"]["location"]["lng"];

      return LatLng(lat, lng);
    }
    return null;
  }

  static LatLng getLatLng(String latLng){
    var array = latLng.split(",");
    var lat = double.parse(array[0]);
    var lng = double.parse(array[1]);
    var l = LatLng(lat, lng);
    return l;
  }

  static Future<String> getAddress(LatLng location) async {
    try {
      var endPoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&key=$apiKey';
      var response = jsonDecode((await http.get(endPoint,
              headers: await LocationUtils.getAppHeaders()))
          .body);
      
      return CyrillicConverter.convertCyrToLat(response['results'][0]['formatted_address']);
    } catch (e) {
      print(e);
    }

    return null;
  }

}