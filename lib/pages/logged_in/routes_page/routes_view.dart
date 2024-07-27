import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/route_model.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_generation_page.dart';

import 'routes_details_page.dart';
import 'select_points_and_generate_route_page.dart';

class RoutesView extends StatefulWidget {
  final Repository repository;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const RoutesView({
    super.key,
    required this.repository,
    required this.auth,
    required this.firestore,
  });

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: widget.repository.getSavedRoutes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<RouteModel> routes = snapshot.data!;
            if (routes.isEmpty) {
              return const Center(
                child: Text("No routes saved yet."),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      // Route to route details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoutesDetailsPage(
                                  index,
                                  routes,
                                  auth: widget.auth,
                                  firestore: widget.firestore,
                                )),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Route name
                          Text(
                            routes[index].getName,
                            key: const Key("routeTitle"),
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),

                          // Route Map display
                          SizedBox(
                            height: 300,
                            width: MediaQuery.of(context).size.width - 28,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: routes[index].getPolylinePoints.first,
                                zoom: 15,
                              ),
                              polylines: {
                                Polyline(
                                  polylineId: const PolylineId('route'),
                                  points:
                                      routes[index].getPolylinePoints.toList(),
                                  color: Colors.blue,
                                  width: 2,
                                  visible: true,
                                  geodesic: true,
                                  jointType: JointType.round,
                                  startCap: Cap.roundCap,
                                  endCap: Cap.roundCap,
                                ),
                              },
                            ),
                          ),
                          const SizedBox(height: 4.0),

                          // Route distance
                          Row(
                            children: [
                              Text(
                                "${routes[index].getDistance} m",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Are you sure dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Route'),
                                        content: const Text(
                                            'Are you sure you want to delete this route?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Delete route
                                              widget.repository.deleteRoute(
                                                  routes[index].getId);
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Route to route generation page
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Choose an Option'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Round loop'),
                        onPressed: () async {
                          Navigator.of(context).pop(); // Close the dialog
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutesGenerationPage(
                                widget.repository,
                              ), // Replace with your first page
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Select your own points'),
                        onPressed: () async {
                          Navigator.of(context).pop(); // Close the dialog
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SelectPointsAndGenerateRoutePage(
                                widget.repository,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          setState(() {});
        },
        label: const Text("Generate Route"),
      ),
    );
  }
}

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  double x0 = 999;
  double x1 = -999;
  double y0 = 999;
  double y1 = -999;
  for (LatLng latLng in list) {
    if (latLng.latitude > x1) x1 = latLng.latitude;
    if (latLng.latitude < x0) x0 = latLng.latitude;
    if (latLng.longitude > y1) y1 = latLng.longitude;
    if (latLng.longitude < y0) y0 = latLng.longitude;
  }
  return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
}
