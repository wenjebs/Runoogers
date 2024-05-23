import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef LocationChangedCallback = void Function(Position newPosition);

class GoogleMapsContainer {
  // Constants
  static const double zoomLevel = 18;
  static const int polylineWidth = 6;
  static const double paddingValue = 24;

  // store the GoogleMapController
  final Completer<GoogleMapController> _controller = Completer();

  // a listener for the current position
  StreamSubscription? _positionSubscription;

  // store the current position
  Position? _currentPosition;

  // Getters
  Completer<GoogleMapController> get controller => _controller;
  StreamSubscription? get positionSubscription => _positionSubscription;
  Position? get currentPosition => _currentPosition;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error message or prompt the user to enable them
      await Geolocator.requestPermission(); // TODO HANDLE NO LOCATION DATA
    }

    // Check if the app has permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permission is denied, ask the user for permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permission is still denied, show an error message or prompt the user to grant permission
        Geolocator.requestPermission(); // TODO HANDLE NO LOCATION DATA
      }
    }

    // Check if the app has background location permission (only for iOS)
    if (permission == LocationPermission.deniedForever) {
      // Background location permission is denied, show an error message or prompt the user to grant permission
      Geolocator.requestPermission();
    }
    debugPrint(permission.toString());
    // Get the current position
    Position newPosition = await Geolocator.getCurrentPosition();
    return newPosition;
    // if (mounted) {
    //   setState(() {});
    // }
  }

  void listenToLocationChanges(callback) async {
    GoogleMapController mapController = await _controller.future;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (newPosition) {
        _currentPosition = newPosition;
        CameraPosition newCameraPosition = CameraPosition(
            zoom: zoomLevel,
            target: LatLng(newPosition.latitude, newPosition.longitude));
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));

        callback(newPosition);
      },
    );

    _controller.future.then((controller) {
      controller.dispose();
    });
  }

  void complete(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void dispose() async {
    _controller.future.then((controller) {
      controller.dispose();
    });

    // Cancel Stream subscription
    await _positionSubscription?.cancel();
  }
}
