import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';

class LocationService {
  // Constants
  final double zoomLevel = 18;

  // a listener for the current position
  static StreamSubscription? _positionSubscription;

  // store the current position and distance travelled;
  static Position? _currentPosition;
  static double distance = 0;

  // getters
  StreamSubscription? get positionSubscription => _positionSubscription;
  Position? get currentPosition => _currentPosition;
  static double get distanceTravelled => distance;

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

  void listenToLocationChanges(
      updateRunPage, Completer<GoogleMapController> controller) async {
    GoogleMapController mapController = await controller.future;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5, // how much distance to move before updating
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (newPosition) {
        // update the distance travelled
        if (_currentPosition != null) {
          debugPrint("updating dist");
          distance += Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            newPosition.latitude,
            newPosition.longitude,
          );
        }

        // update the current position
        _currentPosition = newPosition;

        // update the camera position
        CameraPosition newCameraPosition = CameraPosition(
          zoom: zoomLevel,
          target: LatLng(
            newPosition.latitude,
            newPosition.longitude,
          ),
        );

        // animate the camera to the new position
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(newCameraPosition),
        );

        MapLineDrawer.addPolyPoint(newPosition.latitude, newPosition.longitude);

        /*
        this will update the current position on the map in run_page.dart
        and also redraw the polyline points,
         theres probably a way to do in riverpod but im tired and this works
        */
        updateRunPage(newPosition);
      },
    );

    controller.future.then((controller) {
      controller.dispose();
    });
  }

  // Future<CameraPosition> getCameraPosition() async {
  //   Position pos = await getUserLocation();
  //   return CameraPosition(
  //       target: LatLng(pos.latitude, pos.longitude), zoom: 14);
  // }
  static void stopTrackingLocation() {
    // Cancel Stream subscription
    _positionSubscription?.cancel();
  }

  static void reset() {
    stopTrackingLocation();
    _currentPosition = null;
    distance = 0;
  }
}
