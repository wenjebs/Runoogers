import 'dart:async';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';

class GoogleMapsContainer {
  // store the GoogleMapController
  static Completer<GoogleMapController> _controller = Completer();

  // initialise locationservices class
  final LocationService locationService = LocationService();

  // Getters
  static Completer<GoogleMapController> get controller => _controller;

  // Methods
  // take snapshot
  Future<Uint8List?> takeSnapshot(List<LatLng> list) async {
    final GoogleMapController controller = await _controller.future;
    final LatLngBounds bounds = boundsFromLatLngList(list);
    CameraUpdate update = CameraUpdate.newLatLngBounds(bounds, 50);
    await controller.animateCamera(update);
    await Future.delayed(const Duration(milliseconds: 500));
    final result = await controller.takeSnapshot();
    return result;
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0 = 999;
    double x1 = -999;
    double y0 = 999;
    double y1 = -999;
    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  void complete(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void dispose() {
    // THIS IS VERY IMPORTANT DONT REMOVE IT IDK WHY IT WORKS.
    _controller = Completer();
    _controller.future.then((controller) {
      controller.dispose();
    });
  }
}
