import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/google_maps_container.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LocationService {
  // Constants
  final double zoomLevel = 16;

  // a listener for the current position
  static StreamSubscription? _positionSubscription;

  // store the current position and distance travelled (KM);
  static Position? _currentPosition;
  static double distance = 0;

  // this is for audio playing
  static double distanceTracker = 0;

  // internet status
  static List<ConnectivityResult> connectivityResult = [];

  // location service status
  static bool serviceEnabled = false;
  // getters
  StreamSubscription? get positionSubscription => _positionSubscription;
  Position? get currentPosition => _currentPosition;
  static double get distanceTravelled => distance;
  static double get tracker => distanceTracker;
  static List<ConnectivityResult> get connectivity => connectivityResult;
  static bool get locationServiceEnabled => serviceEnabled;

  void openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  void checkPermission() async {
    debugPrint("location_service: Checking permission");

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error message or prompt the user to enable them
      await Geolocator.requestPermission(); // TODO HANDLE NO LOCATION DATA
    }

    // Check if the app has permission to access location
    LocationPermission permission = await Geolocator.checkPermission();
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

    debugPrint("location service: Checking done");
  }

  Future<Position> getCurrentLocation() async {
    // Get the current position
    Position newPosition = await Geolocator.getCurrentPosition();
    return newPosition;
  }

  void listenToLocationChangesBeforeStart(callback) {
    // debugPrint("location_service:  Listening before start...");
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
            onError: (Object error) =>
                {debugPrint(error.toString()), debugPrint("NOOOO")},
            onDone: () {
              debugPrint('Stream has been closed');
            });
    // debugPrint("location_service:  Listening before start done...");
  }

  void listenToLocationChanges(
    updateRunPage,
    Completer<GoogleMapController> controller,
    bool running,
    bool storyRun,
    AudioPlayer player,
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
          // debugPrint("updating dist");
          distance += Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                newPosition.latitude,
                newPosition.longitude,
              ) /
              1000.0;
        }
        if (storyRun) {
          if (_currentPosition != null) {
            distanceTracker += Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  newPosition.latitude,
                  newPosition.longitude,
                ) /
                1000.0;
            // if its a story run, play audio!
            // check every 100m
            if (tracker >= (0.1)) {
              debugPrint("playing audio");
              playAudio(player);
              distanceTracker = 0;
            }
          }
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

  static void pauseLocationTracking() {
    // Cancel Stream subscription
    _positionSubscription?.pause();
  }

  static void resumeLocationTracking() {
    // Resume Stream subscription
    _positionSubscription?.resume();
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

  void playAudio(AudioPlayer player) async {
    await player.setAsset('lib/assets/audio/cow.mp3');
    player.play();
  }
}
