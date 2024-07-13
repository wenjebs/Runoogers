import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/routes_page/route_model.dart';
import 'package:runningapp/pages/logged_in/routes_page/route_provider.dart';

class SelectPointsAndGenerateRoutePage extends ConsumerStatefulWidget {
  const SelectPointsAndGenerateRoutePage({super.key});

  @override
  ConsumerState<SelectPointsAndGenerateRoutePage> createState() =>
      _SelectPointsAndGenerateRoutePageState();
}

class _SelectPointsAndGenerateRoutePageState
    extends ConsumerState<SelectPointsAndGenerateRoutePage> {
  final _submitFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late Future<Position?> currentLocation;
  bool saved = false;
  bool generated = false;
  Set<Marker> markers = <Marker>{};
  Polyline polyline = const Polyline(
    polylineId: PolylineId('route'),
    color: Colors.blue,
    width: 2,
    visible: true,
    geodesic: true,
    jointType: JointType.round,
    startCap: Cap.roundCap,
    endCap: Cap.roundCap,
  );

  @override
  void initState() {
    currentLocation = Geolocator.getLastKnownPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(pointsRouteProvider(markers));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Points'),
      ),
      body: Center(
        child: Column(
          children: [
            result.isLoading
                ? const SizedBox(
                    height: 500,
                    width: 400,
                    child: Center(child: CircularProgressIndicator()))
                : result.hasError
                    ? Text(result.value.toString())
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: SizedBox(
                              height: 500,
                              width: 400,
                              child: FutureBuilder(
                                  future: currentLocation,
                                  builder: (context, snapshot) {
                                    Set<Marker> allMarkers = <Marker>{};
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      allMarkers.addAll(markers);
                                      allMarkers.add(
                                        Marker(
                                          markerId: const MarkerId("Start"),
                                          position: LatLng(
                                            snapshot.data!.latitude,
                                            snapshot.data!.longitude,
                                          ),
                                          icon: BitmapDescriptor
                                              .defaultMarkerWithHue(
                                                  BitmapDescriptor.hueGreen),
                                        ),
                                      );
                                    }
                                    return snapshot.connectionState ==
                                            ConnectionState.done
                                        ? GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                  snapshot.data!.latitude,
                                                  snapshot.data!.longitude),
                                              zoom: 16,
                                            ),
                                            markers: allMarkers,
                                            polylines: {
                                              Polyline(
                                                polylineId: polyline.polylineId,
                                                points: result.value!,
                                                color: polyline.color,
                                                width: polyline.width,
                                              ),
                                            },
                                            onTap: (coordinate) {
                                              final Marker newMarker = Marker(
                                                markerId: MarkerId(
                                                    coordinate.toString()),
                                                position: coordinate,
                                                onTap: () {
                                                  // remove itself from markers on tap
                                                  setState(() {
                                                    markers.removeWhere(
                                                      (m) =>
                                                          m.markerId ==
                                                          MarkerId(coordinate
                                                              .toString()),
                                                    );
                                                  });
                                                },
                                              );
                                              final Marker existingMarker =
                                                  markers.firstWhere(
                                                (marker) =>
                                                    marker.markerId ==
                                                    newMarker.markerId,
                                                orElse: () => const Marker(
                                                    markerId: MarkerId('')),
                                              );
                                              if (existingMarker
                                                      .markerId.value ==
                                                  '') {
                                                setState(() {
                                                  markers.add(newMarker);
                                                });
                                              }
                                            },
                                          )
                                        : const CircularProgressIndicator();
                                  }),
                            ),
                          ),
                        ),
                      ),
            ElevatedButton(
              onPressed: () {
                // generate a polyline based on the set of markers
                // ignore: unused_result
                if (markers.length > 1) {
                  setState(() {
                    saved = false;
                    generated = true;
                  });
                }
                // ignore: unused_result
                ref.refresh(pointsRouteProvider(markers));
              },
              child: const Text('Generate Route'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  markers.clear();
                  polyline = const Polyline(
                    polylineId: PolylineId('route'),
                    points: [],
                    color: Colors.blue,
                    width: 2,
                    visible: true,
                    geodesic: true,
                    jointType: JointType.round,
                    startCap: Cap.roundCap,
                    endCap: Cap.roundCap,
                  );
                  generated = false;
                });
                // ignore: unused_result
                ref.refresh(pointsRouteProvider(markers));
              },
              child: const Text('Reset'),
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
                        content: const Text("Route has already been saved!"),
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
                        content: const Text("Route has not been generated!"),
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
                bool? save = await _showSaveRouteDialog(
                  Polyline(
                      polylineId: const PolylineId("nil"),
                      points: result.value!),
                );
                if (save != null && save) {
                  setState(() {
                    saved = true;
                  });
                }
              },
              child: const Text("Save route"),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
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
}
