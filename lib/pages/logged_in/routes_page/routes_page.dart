import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/pages/logged_in/routes_page/route_provider.dart';

class RoutesPage extends ConsumerStatefulWidget {
  const RoutesPage({super.key});

  @override
  ConsumerState<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends ConsumerState<RoutesPage> {
  int seed = 0;
  // AsyncValue<Polyline> route =
  //     const AsyncValue.data(Polyline(polylineId: PolylineId('route')));
  AsyncValue<Set<Object>> route = const AsyncValue.loading();
  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    route = ref.watch(routeProvider(seed));
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                    target: LatLng(1.3843113892761545, 103.74289461016552),
                    zoom: 16),
                polylines: {
                  if (route.value != null) route.value!.first as Polyline
                },
                markers: route.value != null
                    ? route.value!.last as Set<Marker>
                    : <Marker>{},
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  debugPrint("refresh");
                  seed = Random().nextInt(90);
                });
              },
              child: const Text("Generate Route"),
            ),
            route.value == null
                ? const CircularProgressIndicator()
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
