import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/runs_provider.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class RunsLoggedPage extends ConsumerWidget {
  const RunsLoggedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(getRunsProvider(Authenticator().userId!));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged Runs'),
      ),
      body: runs.when(
        data: (runs) {
          return ListView(
            children: runs.docs.map((doc) {
              Run run = Run.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>, null);
              return ListTile(
                title: Text(doc['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${run.distance} km"),
                    Text("Time Taken: ${run.time}"),
                    Text("Date: ${run.date}"),
                    SizedBox(
                      height: 300, // adjust as needed
                      child: GoogleMap(
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
    );
  }
}
