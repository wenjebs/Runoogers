import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/google_maps_container.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'loading_map.dart';

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
      floatingActionButton: _isRunning
          ? Animate(
              effects: [
                SlideEffect(
                    duration: 500.ms,
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0)),
              ],
              child: runDetailsAndStop(context),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _isRunning = true;
                });
              },
              label: const Text("Start Run"),
            ),
    );
  }

  Padding runDetailsAndStop(BuildContext context) {
    _stopWatchTimer.onStartTimer();
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: paddingValue, vertical: paddingValue / 2),
      child: Container(
        width: MediaQuery.of(context).size.width - (paddingValue * 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(paddingValue / 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                'TIME',
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  letterSpacing: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  /// Display stop watch time
                  StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        final displayTime =
                            StopWatchTimer.getDisplayTime(value, hours: false);
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                displayTime,
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
            const Divider(),
            const Text(
              'PACE',
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '6 : 00 MIN/KM',
              ),
            ),
            const Divider(),
            const Text(
              'DISTANCE',
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '0 KM',
              ),
            ),
            const Divider(),
            FilledButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(paddingValue / 4),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  // Stop timer.
                  _stopWatchTimer.onStopTimer();
                  // Reset timer
                  _stopWatchTimer.onResetTimer();
                  _isRunning = false;
                });
              },
              child: const Text("Stop Run"),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     body: Text("Hey!"),
  //   );
  // }

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
