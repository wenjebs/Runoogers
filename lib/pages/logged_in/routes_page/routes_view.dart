import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/route_model.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_generation_page.dart';

import 'routes_details_page.dart';
import 'select_points_and_generate_route_page.dart';

class RoutesView extends StatefulWidget {
  final Repository repository;
  final FirebaseAuth auth;
  const RoutesView({super.key, required this.repository, required this.auth});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  // Example list of saved routes. Replace this with your actual data source.
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
                                index, routes,
                                auth: widget.auth)),
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
                                          widget.repository
                                              .deleteRoute(routes[index].getId);
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
