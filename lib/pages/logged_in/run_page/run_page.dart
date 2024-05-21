import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/run_page/location_service.dart';

class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  State<RunPage> createState() {
    return _RunPageState();
  }
}

class _RunPageState extends State<RunPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final LocationService locationService = LocationService();
  Set<Marker> markers = {};
  static CameraPosition position = const CameraPosition(
      target: LatLng(1.6049480942814875, 991.49368172612661), zoom: 14);
  static Marker marker = const Marker(markerId: MarkerId("Current"));

  @override
  void initState() {
    super.initState();
    fetchCameraPosition();
  }

  void fetchCameraPosition() async {
    CameraPosition cp = await locationService.getCameraPosition();
    debugPrint(cp.toString());
    if (mounted) {
      setState(() {
        position = cp;
        marker = Marker(markerId: const MarkerId("first"), position: cp.target);
        markers.add(marker);
      });
    }
  }

  void printLocation() {
    locationService.getUserLocation().then((value) async {
      debugPrint('My Location');
      debugPrint('${value.latitude} ${value.longitude}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("pressed");
          printLocation();
        },
        child: const Icon((Icons.radio_button_off)),
      ),
    );
  }
}
