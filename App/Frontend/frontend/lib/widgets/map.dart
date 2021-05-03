import 'package:Frontend/models/post.dart';
import 'package:Frontend/services/mapServices.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapSize { small, big }

class Map extends StatelessWidget {
  MapSize _size;
  List<Post> _posts;
  LatLng _coords;
  CameraPosition _cameraPosition;
  List<Marker> _markers;

  Map(this._size, this._posts) {
    _coords = MapServices.getLatLng(_posts.first.latLng);
    _markers = List<Marker>();
  }

  void initCameraPosition() {
    _cameraPosition = CameraPosition(
      target: _coords,
      zoom: 17,
    );
  }

  void initMarkers() {
    for (var post in _posts) {
      var marker = Marker(
          markerId: MarkerId(post.id.toString()),
          position: MapServices.getLatLng(post.latLng),
          infoWindow: InfoWindow(
            title: post.description,
          ),
          onTap: () {
            if (_size == MapSize.big) {}
          });

      _markers.add(marker);
    }
  }

  Widget _smallMap(context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _cameraPosition,
            markers: Set<Marker>.of(_markers),
          ),
        ),
      ),
    );
  }

  Widget _bigMap(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition,
        markers: Set<Marker>.of(_markers),
        mapToolbarEnabled: true,
        compassEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initCameraPosition();
    initMarkers();

    if (_size == MapSize.small) return _smallMap(context);
    return _bigMap(context);
  }
}
