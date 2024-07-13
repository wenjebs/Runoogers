import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/routes_page/route_model.dart';
import 'package:runningapp/pages/logged_in/routes_page/route_provider.dart';

class RoutesGenerationPage extends ConsumerStatefulWidget {
  const RoutesGenerationPage({super.key});

  @override
  ConsumerState<RoutesGenerationPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends ConsumerState<RoutesGenerationPage> {
  bool saved = false;
  bool generated = false;
  int seed = 0;
  int distance = 1;
  // AsyncValue<Polyline> route =
  //     const AsyncValue.data(Polyline(polylineId: PolylineId('route')));
  AsyncValue<Set<Object>> route = const AsyncValue.loading();
  GoogleMapController? mapController;
  final distanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _submitFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    route = ref.watch(routeProvider(seed, distance));
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Generate Route"),
        ),
        body: switch (route) {
          AsyncData(:final value) => Center(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: const CameraPosition(
                                // TODO unhardcode this
                                target: LatLng(
                                    1.3843113892761545, 103.74289461016552),
                                zoom: 16),
                            polylines: {value.first as Polyline},
                            markers: value.last as Set<Marker>),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Distance:"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: distanceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              } else if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              } else if (int.parse(value) >= 99) {
                                return 'Please a number less than 99';
                              }
                              return null;
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(
                          () {
                            FocusScope.of(context).unfocus();
                            debugPrint("refresh");
                            seed = Random().nextInt(90);
                            distance = distanceController.text.isNotEmpty
                                ? int.parse(distanceController.text)
                                : 1;
                            distanceController.text = "";
                            saved = false;
                          },
                        );
                      }
                    },
                    child: const Text("Regenerate Route"),
                  ),

                  // save route button
                  ElevatedButton(
                    onPressed: () async {
                      if (saved) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Route already saved!"),
                              content:
                                  const Text("Route has already been saved!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }
                      if (!generated) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Route not generated!"),
                              content:
                                  const Text("Route has not been generated!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }
                      // debugPrint(value.first.toString());
                      Polyline encoded = value.first as Polyline;
                      bool? save = await _showSaveRouteDialog(encoded);
                      if (save != null && save) {
                        setState(() {
                          saved = true;
                        });
                      }
                    },
                    child: const Text("Save route"),
                  ),
                ],
              ),
            ),
          AsyncError(:final error) => Text("No internet/ API Down :()\n$error"),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    distanceController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool?> _showSaveRouteDialog(Polyline encoded) async {
    final result = showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Route'),
          content: Form(
            key: _submitFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () => _saveRoute(encoded),
            ),
          ],
        );
      },
    );
    return result;
  }

  bool _saveRoute(Polyline encoded) {
    if (_submitFormKey.currentState!.validate()) {
      // Use the name and description from the controllers
      String name = _nameController.text;
      String description = _descriptionController.text;
      Repository.saveRoute(
        RouteModel(
            id: "",
            name: name,
            description: description,
            distance: calculateDistance(encoded.points).toInt().toString(),
            polylinePoints: encoded.points.toSet(),
            imageUrl: "32"),
      );
      // Close the dialog
      Navigator.of(context).pop(true);
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Route saved!'),
        ),
      );
    }
    return false;
  }
}

Set<LatLng> convertPolylineToLatLngSet(String polyline) {
  PolylinePoints polylinePoints = PolylinePoints();
  List<PointLatLng> points = polylinePoints.decodePolyline(polyline);
  Set<LatLng> latLngSet =
      points.map((point) => LatLng(point.latitude, point.longitude)).toSet();
  return latLngSet;
}

double calculateDistance(List<LatLng> polyline) {
  double totalDistance = 0;
  for (int i = 0; i < polyline.length; i++) {
    if (i < polyline.length - 1) {
      // skip the last index
      totalDistance += Geolocator.distanceBetween(
          polyline[i + 1].latitude,
          polyline[i + 1].longitude,
          polyline[i].latitude,
          polyline[i].longitude);
    }
  }
  return totalDistance;
}
