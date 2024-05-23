import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLineDrawer {
  // TEMPORARY
  PointLatLng starttest = const PointLatLng(
      1.38421039476496, 103.7428801911649); // TODO REMOVE THIS SHIT
  PointLatLng startend =
      const PointLatLng(1.3847101970640396, 103.75290227627711);

  // store coordinates for drawing the map line
  final List<LatLng> _polylineCoordinates = [];

  // getter
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    var result = await polylinePoints.getRouteBetweenCoordinates(
        dotenv.env['MAPS_API_KEY']!, starttest, startend);

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
  }

  void clear() {
    _polylineCoordinates.clear();
  }
}
