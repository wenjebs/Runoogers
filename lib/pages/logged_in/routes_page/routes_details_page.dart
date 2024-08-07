import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/route_model.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';

class RoutesDetailsPage extends StatelessWidget {
  final List<RouteModel> routes;
  final int index;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const RoutesDetailsPage(
    this.index,
    this.routes, {
    super.key,
    required this.auth,
    required this.firestore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Map
            SizedBox(
              height: 500,
              child: SizedBox(
                child: Card(
                  elevation: 10.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: routes[index].getPolylinePoints.first,
                        zoom: 16,
                      ),
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('route'),
                          points: routes[index].getPolylinePoints.toList(),
                          color: Colors.blue,
                          width: 2,
                          visible: true,
                          geodesic: true,
                          jointType: JointType.round,
                          startCap: Cap.roundCap,
                          endCap: Cap.roundCap,
                        )
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Route details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    routes[index].getName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Distance: ${routes[index].distance} m',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Start run button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to run page with the selected route
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RunPage(
                              locationService: LocationService(),
                              repository: Repository(),
                              route: routes[index],
                              storyRun: false,
                              title: "Route run",
                              auth: auth,
                              firestore: firestore,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Start Run'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
