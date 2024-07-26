import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/route_model.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/google_maps_container.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:runningapp/models/progress_model.dart';
import 'package:runningapp/providers.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'map_and_location_logic/loading_map.dart';
import 'components/run_detail_and_stop.dart';

class RunPage extends ConsumerStatefulWidget {
  final Repository repository;
  final bool storyRun;
  final String title;

// possible route
  final RouteModel? route;
  // quest fields
  final double? questDistance;
  final String? activeStoryTitle;
  final QuestProgressModel? questProgress;
  final int? currentQuest;

  final LocationService locationService;

  final Position? currPos;

  final FirebaseAuth auth;

  const RunPage({
    super.key,
    this.route,
    required this.storyRun,
    required this.title,
    this.activeStoryTitle,
    this.questProgress,
    this.questDistance,
    this.currentQuest,
    required this.repository,
    required this.locationService,
    this.currPos,
    required this.auth,
  });

  @override
  ConsumerState<RunPage> createState() {
    return _RunPageState();
  }
}

class _RunPageState extends ConsumerState<RunPage> {
  // Is this a run initiated from story page?
  bool storyRun = false;
  // Current Position
  Position? currPos;
  // Intiaise Google Map Container
  final GoogleMapsContainer googleMapsContainer = GoogleMapsContainer();

  // Initialise stopwatch
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  // icons for start, end, current
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  // Constants
  static const double zoomLevel = 18;
  static const int polylineWidth = 6;
  static const double paddingValue = 24;

  @override
  void initState() {
    super.initState();
    if (widget.currPos != null) {
      currPos = widget.currPos;
    }
    LocationService.initialize();
    storyRun = widget.storyRun;
    checkPermission();
    widget.locationService.listenToLocationChangesBeforeStart(
      (newPos) => {
        if (mounted)
          {
            setState(
              () {
                currPos = newPos;
              },
            )
          }
      },
    );
    init();
  }

  Future<void> checkPermission() async {
    await widget.locationService.checkPermission();
  }

  init() async {
    debugPrint("run_page : getting initial position");
    Position? initialPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      debugPrint("run_page : getting initial position done");
      currPos = initialPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = ref.watch(timerProvider);
    return Scaffold(
      appBar: storyRun
          ? isRunning
              ? AppBar(
                  centerTitle: true,
                  title: const Text(
                    "Running",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ))
              : AppBar(
                  centerTitle: true,
                  title: Text(
                    widget.title,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ))
          : null,
      body: currPos == null
          ? widget.locationService.locationServiceEnabled
              ? widget.locationService.connectivity
                      .contains(ConnectivityResult.none)
                  ? const Text("NO internet!") // TODO make nicer
                  : const LoadingMap()
              : DisabledLocationWidget(
                  callback: setState,
                  locationService: widget.locationService,
                )
          : SafeArea(
              child: Builder(builder: (context) {
                return GoogleMap(
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currPos!.latitude, currPos!.longitude),
                    zoom: zoomLevel,
                  ),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("draw"),
                      points: MapLineDrawer.polylineCoordinates,
                      color: Colors.red,
                      width: polylineWidth,
                    ),
                    widget.route != null
                        ? Polyline(
                            polylineId: const PolylineId("route"),
                            points: widget.route!.getPolylinePoints.toList(),
                            color: Colors.blue,
                            width: 2,
                          )
                        : const Polyline(
                            polylineId: PolylineId("route"),
                            color: Colors.blue,
                            width: 2,
                          ),
                  },
                  mapType: MapType.normal,
                  markers: {
                    Marker(
                      icon: currentIcon,
                      markerId: const MarkerId("current"),
                      position: LatLng(currPos!.latitude, currPos!.longitude),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    if (mounted) {
                      setState(() {
                        Completer<GoogleMapController> mapCompleter =
                            GoogleMapsContainer.controller;
                        if (!mapCompleter.isCompleted) {
                          googleMapsContainer.complete(controller);
                        }
                        // googleMapsContainer.complete(controller);
                      });
                    }
                  },
                );
              }),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final isRunning = ref.watch(timerProvider);
          return currPos == null
              ? const SizedBox()
              : isRunning
                  ? Animate(
                      effects: [
                        SlideEffect(
                            duration: 500.ms,
                            begin: const Offset(0, 1),
                            end: const Offset(0, 0)),
                      ],
                      child: RunDetailsAndStop(
                        firestore: FirebaseFirestore.instance,
                        locationService: widget.locationService,
                        widget.repository,
                        paddingValue: paddingValue,
                        stopWatchTimer: _stopWatchTimer,
                        context: context,
                        mapContainer: googleMapsContainer,
                        questProgress: widget.questProgress,
                        activeStory: widget.activeStoryTitle,
                        storyRun: storyRun,
                        auth: widget.auth,
                      ),
                    )
                  : FloatingActionButton.large(
                      onPressed: () {
                        // update the state of running
                        ref.read(timerProvider.notifier).startStopTimer();

                        // start the timer
                        _stopWatchTimer.onStartTimer();

                        // start location tracking
                        LocationService.reset();
                        LocationService.initialize();
                        widget.locationService.listenToLocationChanges(
                          (Position newPos) => setState(() {
                            currPos = newPos;
                          }),
                          GoogleMapsContainer.controller,
                          true,
                          storyRun,
                          widget.questDistance,
                          widget.activeStoryTitle,
                          widget.currentQuest,
                        );

                        if (storyRun) {
                          LocationService.playBGMusic(
                            widget.activeStoryTitle,
                            widget.currentQuest,
                          );
                          LocationService.playEventAudio(
                              "lib/assets/audio/${widget.activeStoryTitle}${widget.currentQuest! + 1}/${widget.activeStoryTitle}start.mp3");
                        }
                      },
                      shape: const CircleBorder(),
                      key: const Key('startButton'),
                      child: const Text(
                        "Start",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // reset location services
    LocationService.reset();

    // Release Google Map Controller
    googleMapsContainer.dispose();

    // Clear polylines and markers
    MapLineDrawer.clear();

    _stopWatchTimer.dispose();
  }
}

class DisabledLocationWidget extends StatelessWidget {
  final Function callback;
  final LocationService locationService;

  const DisabledLocationWidget({
    super.key,
    required this.callback,
    required this.locationService,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Location services are disabled!"),
          const Text("Please enable location services to continue."),
          ElevatedButton(
              onPressed: () {
                locationService.openLocationSettings();
                // locationService.checkPermission();
                debugPrint("setstate of run page after enable pressed");
                callback(() {});
              },
              child: const Text("Enable Location Services")),
        ],
      ),
    );
  }
}
