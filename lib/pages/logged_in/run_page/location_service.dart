import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<CameraPosition> getCameraPosition() async {
    Position pos = await getUserLocation();
    return CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 14);
  }
}
