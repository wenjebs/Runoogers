import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/routes_page/route_model.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_generation_page.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  // Example list of saved routes. Replace this with your actual data source.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Routes'),
      ),
      body: FutureBuilder(
        future: Repository.getSavedRoutes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<RouteModel> routes = snapshot.data!;
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
                            builder: (context) =>
                                RoutesDetailsPage(index, routes)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                "${routes[index].getDistance} m",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
                                          Repository.deleteRoute(
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
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RoutesGenerationPage(),
            ),
          );
          setState(() {});
        },
        label: const Text("Generate Route"),
      ),
    );
  }
}

class RoutesDetailsPage extends StatelessWidget {
  final List<RouteModel> routes;
  final int index;
  const RoutesDetailsPage(this.index, this.routes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Map
            SizedBox(
              height: 500,
              child: SizedBox(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
