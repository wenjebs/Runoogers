import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
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
  Position? currentPosition;
  StreamSubscription? _positionSubscription;
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  PointLatLng starttest =
      const PointLatLng(1.38421039476496, 103.7428801911649);
  PointLatLng startend =
      const PointLatLng(1.3847101970640396, 103.75290227627711);

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        dotenv.env['MAPS_API_KEY']!, starttest, startend);

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition();
    currentPosition = newPosition;
    if (mounted) {
      setState(() {});
    }
    GoogleMapController mapController = await _controller.future;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (newPosition) {
        currentPosition = newPosition;
        CameraPosition newCameraPosition = CameraPosition(
            zoom: 18,
            target: LatLng(newPosition.latitude, newPosition.longitude));
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPolyPoints();
  }

  void printLocation() {
    locationService.getUserLocation().then((value) async {
      if (kDebugMode) {
        print('My Location');
        print('${value.latitude} ${value.longitude}');
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
      body: currentPosition == null
          ? const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Loading"),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : SafeArea(
              child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentPosition!.latitude, currentPosition!.longitude),
                zoom: 14,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.red,
                  width: 6,
                )
              },
              mapType: MapType.normal,
              markers: {
                Marker(
                    icon: sourceIcon,
                    markerId: const MarkerId("start"),
                    position: LatLng(starttest.latitude, starttest.longitude)),
                Marker(
                    icon: destinationIcon,
                    markerId: const MarkerId("end"),
                    position: LatLng(startend.latitude, startend.longitude)),
                Marker(
                  icon: currentIcon,
                  markerId: const MarkerId("current"),
                  position: LatLng(
                      currentPosition!.latitude, currentPosition!.longitude),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                if (mounted) {
                  setState(() {
                    _controller.complete(controller);
                  });
                }
              },
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
          printLocation();
        },
        child: const Icon((Icons.radio_button_off)),
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
    // Release Google Map Controller
    _controller.future.then((controller) {
      controller.dispose();
    });

    // Clear polylines and markers
    polylineCoordinates.clear();

// Cancel Stream subscription
    _positionSubscription?.cancel();
    super.dispose();
  }
}
