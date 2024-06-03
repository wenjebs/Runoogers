import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/runs_provider.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class RunsSection extends ConsumerWidget {
  const RunsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(getRunsProvider(Authenticator().userId!));
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(30),
              child: runs.when(
                data: (runs) {
                  return ListView(
                    children: runs.docs.map((doc) {
                      Run run = Run.fromFirestore(
                          doc as DocumentSnapshot<Map<String, dynamic>>, null);
                      return ListTile(
                        title: Text(doc['name'],
                            style: Theme.of(context).textTheme.headlineMedium),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: ${run.date}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Text("Distance"),
                                      Text("${run.distance} km"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Text("Time"),
                                      Text(run.time),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Text("Pace"),
                                      Text("hehe")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300, // adjust as needed
                              child: GoogleMap(
                                zoomControlsEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: run.getPolylinePoints
                                      .first, // assuming Run has a position field of type LatLng
                                  zoom: 14,
                                ),
                                polylines: {
                                  Polyline(
                                    polylineId: const PolylineId('route'),
                                    color: Colors.red,
                                    points: run
                                        .getPolylinePoints, // assuming Run has a polylineCoordinates field of type List<LatLng>
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
