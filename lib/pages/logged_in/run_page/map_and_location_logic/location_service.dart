import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/google_maps_container.dart';

class LocationService {
  // Constants
  final double zoomLevel = 16;

  // a listener for the current position
  static StreamSubscription? _positionSubscription;

  // store the current position and distance travelled;
  static Position? _currentPosition;
  static double distance = 0;

  // getters
  StreamSubscription? get positionSubscription => _positionSubscription;
  Position? get currentPosition => _currentPosition;
  static double get distanceTravelled => distance;

  void checkPermission() async {
    debugPrint("Checking permission");
    // TODO this function could be better but im laze
    bool serviceEnabled;
    // LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error message or prompt the user to enable them
      await Geolocator.requestPermission(); // TODO HANDLE NO LOCATION DATA
    }

    // // Check if the app has permission to access location
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   // Location permission is denied, ask the user for permission
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     // Location permission is still denied, show an error message or prompt the user to grant permission
    //     Geolocator.requestPermission(); // TODO HANDLE NO LOCATION DATA
    // }
    // }

    // // Check if the app has background location permission (only for iOS)
    // if (permission == LocationPermission.deniedForever) {
    //   // Background location permission is denied, show an error message or prompt the user to grant permission
    //   Geolocator.requestPermission();
    // }
    debugPrint("Checking done");
  }

  Future<Position> getCurrentLocation() async {
    // Get the current position
    Position newPosition = await Geolocator.getCurrentPosition();
    return newPosition;
  }

  void listenToLocationChangesBeforeStart(callback) {
    debugPrint("Listening before start...");
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5, // how much distance to move before updating
    );
    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (newPosition) {
              _currentPosition = newPosition;
              callback(newPosition);
              // update the camera position
              CameraPosition newCameraPosition = CameraPosition(
                zoom: zoomLevel,
                target: LatLng(
                  newPosition.latitude,
                  newPosition.longitude,
                ),
              );

              // animate the camera to the new position
              GoogleMapsContainer.controller.future.then(
                (controller) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(newCameraPosition),
                  );
                },
              );
            },
            onError: (Object error) => debugPrint("NOOOO"),
            onDone: () {
              debugPrint('Stream has been closed');
            });
    debugPrint("Listening before start done...");
  }

  void listenToLocationChanges(
    updateRunPage,
    Completer<GoogleMapController> controller,
    bool running,
  ) async {
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

        if (_currentPosition != null) {
          MapLineDrawer.addPolyPoint(
              _currentPosition!.latitude, _currentPosition!.longitude);
        }

        /*
        this will update the current position on the map in run_page.dart
        and also redraw the polyline points,
         theres probably a way to do in riverpod but im tired and this works
        */
        // debugPrint("updating run page");
        updateRunPage(newPosition);
      },
    );

    controller.future.then((controller) {
      controller.dispose();
    });
  }

  static void stopTrackingLocation() {
    // Cancel Stream subscription
    _positionSubscription?.cancel();
  }

  static void reset() {
    // very important too! if not the page wont load when you go back in
    stopTrackingLocation();
    _currentPosition = null;
    distance = 0;
  }
}
