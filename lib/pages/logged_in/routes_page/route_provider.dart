import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runningapp/main.dart';

part 'route_provider.g.dart';

@riverpod
Future<Set<Object>> route(RouteRef ref, int seed, int distance) async {
  final OpenRouteService client = OpenRouteService(apiKey: orsApiKey);

  final List<ORSCoordinate> test = [
    const ORSCoordinate(
        latitude: 1.384320955589256, longitude: 103.74288823076182)
  ];

  // Form Route between coordinates

  final List<ORSCoordinate> testRoute =
      await client.directionsMultiRouteCoordsPost(coordinates: test, options: {
    "round_trip": {"length": distance * 1000, "points": 5, "seed": seed}
  });

  final List<DirectionRouteData> abc = await client
      .directionsMultiRouteDataPost(coordinates: test, alternativeRoutes: {
    "target_count": 0
  }, options: {
    "round_trip": {"length": distance * 1000, "points": 5, "seed": seed}
  });

  Set<Marker> markers = <Marker>{};
  for (var routedata in abc) {
    for (var seg in routedata.segments) {
      for (var step in seg.steps) {
        markers.add(Marker(
          markerId: MarkerId(step.wayPoints[0].toString()),
          position: LatLng(testRoute[step.wayPoints[0].floor()].latitude,
              testRoute[step.wayPoints[0].floor()].longitude),
        ));
      }
    }
    // final pointCount = routedata.wayPoints[1];
  }
  // Map route coordinates to a list of LatLng (requires google_maps_flutter package)
  // to be used in the Map route Polyline.
  final List<LatLng> routePoints = testRoute
      .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
      .toList();

  // Create Polyline (requires Material UI for Color)
  final Polyline routePolyline = Polyline(
    polylineId: const PolylineId('route'),
    visible: true,
    points: routePoints,
    color: Colors.red,
    width: 3,
  );

  return {routePolyline, markers};
}

@riverpod
Future<List<LatLng>> pointsRoute(
    PointsRouteRef ref, Set<Marker> markers) async {
  if (markers.length <= 1) {
    return [];
  }
  // Convert set of markers to list of ORS coordinates
  final List<ORSCoordinate> coordinates = markers
      .map((marker) => ORSCoordinate(
          latitude: marker.position.latitude,
          longitude: marker.position.longitude))
      .toList();

  // Form Route between coordinates
  final OpenRouteService client = OpenRouteService(apiKey: orsApiKey);

  final List<ORSCoordinate> route = await client.directionsMultiRouteCoordsPost(
    coordinates: coordinates,
  );

  // Map route coordinates to a list of LatLng to be used in the Map route Polyline.
  final List<LatLng> routePoints = route
      .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
      .toList();

  return routePoints;
}
