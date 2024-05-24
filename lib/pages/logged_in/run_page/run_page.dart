import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/google_maps_container.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:runningapp/providers.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'map_and_location_logic/loading_map.dart';
import 'components/run_detail_and_stop.dart';

class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  State<RunPage> createState() {
    return _RunPageState();
  }
}

class _RunPageState extends State<RunPage> {
  // Current Position
  Position? currPos;

  // Initialise location services
  final LocationService locationService = LocationService();

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

    // get current location and set it to currPos
    locationService.getCurrentLocation().then((position) {
      currPos = position;
      if (mounted) {
        setState(() {});
      }
    });
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
                  context: context,
                )
              : FloatingActionButton.extended(
                  onPressed: () {
                    // update the state of running
                    ref.read(timerProvider.notifier).startStopTimer();

                    // start the timer
                    _stopWatchTimer.onStartTimer();

                    // start location tracking
                    locationService.listenToLocationChanges(
                        (Position newPos) => setState(() {
                              currPos = newPos;
                            }),
                        googleMapsContainer.controller);
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
