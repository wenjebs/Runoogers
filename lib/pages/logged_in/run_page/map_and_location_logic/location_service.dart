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

  // this is for audio playing purposes to know when to play audio
  static double distanceTracker = 0;

  // audio players
  static AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  static AudioPlayer _eventAudioPlayer = AudioPlayer();

  // internet status
  static List<ConnectivityResult> connectivityResult = [];

  // location service status
  static bool serviceEnabled = false;
  // getters
  StreamSubscription? get positionSubscription => _positionSubscription;
  Position? get currentPosition => _currentPosition;
  double get distanceTravelled => distance;
  static double get tracker => distanceTracker; // in km
  List<ConnectivityResult> get connectivity => connectivityResult;
  bool get locationServiceEnabled => serviceEnabled;

  // for story run audios
  int idx = 1;
  bool endPlayed = false;

  static void initialize() {
    // Initialize background music player
    _backgroundMusicPlayer = AudioPlayer();
    _eventAudioPlayer = AudioPlayer();
  }

  static Future<void> playBGMusic(
    String? activeStoryTitle,
    int? currentQuest,
  ) async {
    // Play the background music
    debugPrint("playing bg audio");
    debugPrint(activeStoryTitle!);
    await _backgroundMusicPlayer.setAsset(
        'lib/assets/audio/$activeStoryTitle$currentQuest/${activeStoryTitle}bg.mp3');
    // cb.. need delete apk and reinstall when moving audio files
    _backgroundMusicPlayer.setVolume(0.5); // Set a lower volume
    _backgroundMusicPlayer.setLoopMode(LoopMode.one);
    _backgroundMusicPlayer.play();
  }

  static Future<void> playEventAudio(String assetPath) async {
    // Play a specific audio for an event
    debugPrint(assetPath);
    await _eventAudioPlayer.setAsset(assetPath);
    await _eventAudioPlayer.play();
  }

  void openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> checkPermission() async {
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

  static void stopListeningToLocationChanges() {
    // Cancel Stream subscription
    _positionSubscription?.cancel();
  }

  void listenToLocationChanges(
    updateRunPage,
    Completer<GoogleMapController> controller,
    bool running,
    bool storyRun,
    double? questDistance,
    String? activeStoryTitle,
    int? currentQuest,
  ) async {
    GoogleMapController mapController = await controller.future;
    int lastKmPlayed = 0;
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5, // how much distance to move before updating
    );
    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (newPosition) {
        // update the distance travelled
        if (_currentPosition != null) {
          final calculatedDist = Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                newPosition.latitude,
                newPosition.longitude,
              ) /
              1000.0;
          // debugPrint("updating dist$distanceTravelled");
          distance += calculatedDist;
          if (storyRun) {
            distanceTracker += calculatedDist;
            debugPrint("tracker value: $tracker");
            if (tracker >= lastKmPlayed + 1 && tracker < questDistance!) {
              // play audio every 1km
              playEventAudio(
                  "lib/assets/audio/$activeStoryTitle${currentQuest! + 1}/$activeStoryTitle$idx.mp3");
              idx++;
              lastKmPlayed++;
            } else if (tracker >= questDistance! && !endPlayed) {
              // play audio when quest is completed
              playEventAudio(
                  "lib/assets/audio/$activeStoryTitle${currentQuest! + 1}/${activeStoryTitle}end.mp3");
              endPlayed = true;
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
    _backgroundMusicPlayer.dispose();
    _eventAudioPlayer.dispose();
  }

  static void reset() {
    // very important too! if not the page wont load when you go back in
    stopTrackingLocation();
    _currentPosition = null;
    distance = 0;
    distanceTracker = 0;
    _backgroundMusicPlayer.dispose();
    _eventAudioPlayer.dispose();
  }

  void playAudio(AudioPlayer player) async {
    await player.setAsset('lib/assets/audio/cow.mp3');
    player.play();
  }
}
