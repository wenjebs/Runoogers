import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';

typedef LocationChangedCallback = void Function(Position newPosition);

class GoogleMapsContainer {
  // store the GoogleMapController
  final Completer<GoogleMapController> _controller = Completer();

  // initialise locationservices class
  final LocationService locationService = LocationService();

  // Getters
  Completer<GoogleMapController> get controller => _controller;

  void complete(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void dispose() {
    _controller.future.then((controller) {
      controller.dispose();
    });
  }
}
