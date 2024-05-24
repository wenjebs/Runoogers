// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLineDrawer {
  // store coordinates for drawing the map line
  static final List<LatLng> _polylineCoordinates = [];

  // getter
  static List<LatLng> get polylineCoordinates => _polylineCoordinates;

  // void getPolyPoints() async {
  //   PolylinePoints polylinePoints = PolylinePoints();

  //   var result = await polylinePoints.getRouteBetweenCoordinates(
  //       dotenv.env['MAPS_API_KEY']!, starttest, startend);

  //   if (result.points.isNotEmpty) {
  //     for (PointLatLng point in result.points) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     }
  //   }
  // }

  static void addPolyPoint(double latitude, double longitude) {
    _polylineCoordinates.add(LatLng(latitude, longitude));
  }

  static void clear() {
    _polylineCoordinates.clear();
  }
}
