import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/google_maps_container.dart';
import 'package:runningapp/providers.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'loading_map.dart';
import 'run_detail_and_stop.dart';

class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  State<RunPage> createState() {
    return _RunPageState();
  }
}

class _RunPageState extends State<RunPage> {
  // TEMPORARY
  PointLatLng starttest = const PointLatLng(
      1.38421039476496, 103.7428801911649); // TODO REMOVE THIS SHIT
  PointLatLng startend =
      const PointLatLng(1.3847101970640396, 103.75290227627711);

  bool _isRunning = false;

  // Current Position
  Position? currPos;

  // Intiaise Google Map Container
  final GoogleMapsContainer googleMapsContainer = GoogleMapsContainer();

  // Initialise Poly Line drawer
  final MapLineDrawer mapLineDrawer = MapLineDrawer();

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
    googleMapsContainer.getCurrentLocation().then((position) {
      currPos = position;
      setState(() {});
    });
    googleMapsContainer
        .listenToLocationChanges((Position newPos) => setState(() {
              currPos = newPos;
            }));
    mapLineDrawer.getPolyPoints();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Track run",
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: currPos == null
          ? const LoadingMap()
          : SafeArea(
              child: GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(currPos!.latitude, currPos!.longitude),
                  zoom: zoomLevel,
                ),
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: mapLineDrawer.polylineCoordinates,
                    color: Colors.red,
                    width: polylineWidth,
                  )
                },
                mapType: MapType.normal,
                markers: {
                  Marker(
                      icon: sourceIcon,
                      markerId: const MarkerId("start"),
                      position:
                          LatLng(starttest.latitude, starttest.longitude)),
                  Marker(
                      icon: destinationIcon,
                      markerId: const MarkerId("end"),
                      position: LatLng(startend.latitude, startend.longitude)),
                  Marker(
                    icon: currentIcon,
                    markerId: const MarkerId("current"),
                    position: LatLng(currPos!.latitude, currPos!.longitude),
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  if (mounted) {
                    setState(() {
                      googleMapsContainer.controller.complete(controller);
                      // googleMapsContainer.complete(controller);
                    });
                  }
                },
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final isRunning = ref.watch(timerProvider);
          return isRunning
              ? RunDetailsAndStop(
                  paddingValue: paddingValue,
                  stopWatchTimer: _stopWatchTimer,
                  context: context)
              : FloatingActionButton.extended(
                  onPressed: () {
                    // update the state of running
                    ref.read(timerProvider.notifier).startStopTimer();

                    // start the timer
                    _stopWatchTimer.onStartTimer();
                  },
                  label: const Text("Start Run"),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Release Google Map Controller
    googleMapsContainer.dispose();

    // Clear polylines and markers
    mapLineDrawer.clear();

    _stopWatchTimer.dispose();
  }
}
