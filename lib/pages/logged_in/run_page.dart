import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunPage extends StatefulWidget {
  const RunPage({super.key});

  @override
  State<RunPage> createState() {
    return _RunPageState();
  }
}

class _RunPageState extends State<RunPage> {
  final Completer<GoogleMapController> _controller = Completer();
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
    CameraPosition cp = await getCameraPosition();
    print(cp.toString());
    setState(() {
      position = cp;
      marker = Marker(markerId: const MarkerId("first"), position: cp.target);
      markers.add(marker);
    });
  }

  Future<CameraPosition> getCameraPosition() async {
    Position pos = await getUserLocation();
    return CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 14);
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

  void packData() {
    getUserLocation().then((value) async {
      print('My Location');
      print('${value.latitude} ${value.longitude}');
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
          packData();
        },
        child: const Icon((Icons.radio_button_off)),
      ),
    );
  }
}
