import 'package:Frontend/config/config.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

class MapLocationPicker extends StatefulWidget {
  @override
  _MapLocationPickerState createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  LocationResult _pickedLocation;


  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    LocationResult result = await showLocationPicker(
                      context,
                      apiKey,
                      //initialCenter: LatLng(31.1975844, 29.9598339),
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                      myLocationButtonEnabled: true,
                      layersButtonEnabled: true,
//                      resultCardAlignment: Alignment.bottomCenter,

                    );
                    print("result = $result");
                    setState(() => _pickedLocation = result);
                  },
                  child: Text('Izaberite lokaciju'),
                ),
                Text(_pickedLocation.toString()),
              ],
            ),
          );
  }
}