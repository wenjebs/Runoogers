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
  int distance = 1;
  // AsyncValue<Polyline> route =
  //     const AsyncValue.data(Polyline(polylineId: PolylineId('route')));
  AsyncValue<Set<Object>> route = const AsyncValue.loading();
  GoogleMapController? mapController;
  final distanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          body: switch (route) {
        AsyncData(:final value) => Center(
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: const CameraPosition(
                          // TODO unhardcode this
                          target:
                              LatLng(1.3843113892761545, 103.74289461016552),
                          zoom: 16),
                      polylines: {value.first as Polyline},
                      markers: value.last as Set<Marker>),
                ),
                Column(
                  children: [
                    const Text("Distance:"),
                    // NumberPicker(
                    //   value: distance,
                    //   itemCount: 3,
                    //   minValue: 1,
                    //   maxValue: 100,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       distance = value;
                    //     });
                    //   },
                    //   selectedTextStyle:
                    //       // TODO change this
                    //       const TextStyle(color: Colors.blue),
                    //   itemHeight: 25,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.blue),
                    //   ),
                    // ),
                    Form(
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
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        debugPrint("refresh");
                        seed = Random().nextInt(90);
                        distance = distanceController.text.isNotEmpty
                            ? int.parse(distanceController.text)
                            : 1;
                        distanceController.text = "";
                      });
                    }
                  },
                  child: const Text("Regenerate Route"),
                ),
                route.value == null
                    ? const CircularProgressIndicator()
                    : const SizedBox()
              ],
            ),
          ),
        AsyncError(:final error) => Text("No internet/ API Down :()\n$error"),
        _ => const Center(child: CircularProgressIndicator()),
      }),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    distanceController.dispose();
    super.dispose();
  }
}
