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
  Future<Uint8List?> takeSnapshot() async {
    final GoogleMapController controller = await _controller.future;
    final result = await controller.takeSnapshot();
    return result;
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
