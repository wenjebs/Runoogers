import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/google_maps_container.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:runningapp/pages/logged_in/run_page/paused_page/paused_page.dart';
import 'package:runningapp/providers.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RunDetailsAndStop extends ConsumerWidget {
  RunDetailsAndStop({
    super.key,
    required this.paddingValue,
    required StopWatchTimer stopWatchTimer,
    required this.context,
    required this.mapContainer,
  }) : _stopWatchTimer = stopWatchTimer;

  final imagesRef = FirebaseStorage.instance.ref().child('images');
  final double paddingValue;
  final StopWatchTimer _stopWatchTimer;
  final GoogleMapsContainer mapContainer;
  final BuildContext context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isHidden = ref.watch(runDetailsProvider);
    return isHidden
        ? FilledButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    paddingValue / 4,
                  ),
                ),
              ),
            ),
            onPressed: () {
              ref.read(runDetailsProvider.notifier).showHideRunDetails();
            },
            child: const Text("Show Details"),
          )
        : Animate(
            effects: [
              SlideEffect(
                  duration: 200.ms,
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0)),
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: paddingValue,
                vertical: paddingValue / 2,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - (paddingValue * 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(paddingValue / 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'TIME',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          /// Display stop watch time
                          StreamBuilder<int>(
                              stream: _stopWatchTimer.rawTime,
                              initialData: _stopWatchTimer.rawTime.value,
                              builder: (context, snap) {
                                final value = snap.data!;
                                final displayTime =
                                    StopWatchTimer.getDisplayTime(value,
                                        hours: false);
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        displayTime,
                                        style: const TextStyle(
                                            fontSize: 40,
                                            fontFamily: 'Helvetica',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                    const Divider(
                      indent: 40,
                      endIndent: 40,
                    ),
                    const Text(
                      'PACE',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snap) {
                            // debugPrint((snap.data! / 1000).toString());
                            final value = snap.data!;
                            final currentTime = value;
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    LocationService.distanceTravelled == 0
                                        ? '0'
                                        : "${((currentTime / 60000) / LocationService.distanceTravelled).toStringAsFixed(2)} min/km",
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                    const Divider(
                      indent: 40,
                      endIndent: 40,
                    ),
                    const Text(
                      'DISTANCE',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        '${LocationService.distanceTravelled.toStringAsFixed(2)} KM',
                        style: const TextStyle(
                          fontSize: 40,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // STOP RUN BUTTON AND HIDE BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // STOP BUTTON
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(paddingValue / 4),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // stop timer
                              _stopWatchTimer.onStopTimer();

                              // get the time
                              final int time = _stopWatchTimer.rawTime.value;

                              // get distance travelled
                              final double distance =
                                  LocationService.distanceTravelled;

                              // get pace of run
                              final double pace = (time / 60000) / distance;

                              // show completed run details
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Run Completed"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Time: ${StopWatchTimer.getDisplayTime(time, hours: false)}",
                                        ),
                                        Text(
                                          "Distance: $distance",
                                        ),
                                        Text(
                                          "Pace: $pace min/km",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Close"),
                                      ),
                                    ],
                                  );
                                },
                              );
                              // get runs done
                              final String username =
                                  await Repository.fetchName(
                                      FirebaseAuth.instance.currentUser!.uid);
                              final int runsDone =
                                  await Repository.getRunsDone();

                              //take screenshot of current run and upload to fb
                              final screenshot =
                                  await mapContainer.takeSnapshot();
                              if (screenshot != null) {
                                final Directory tempDir =
                                    await getTemporaryDirectory();
                                final path = tempDir.path;
                                final imageFile =
                                    File('$path/$username$runsDone.png');
                                // Write the screenshot data to the file
                                await imageFile.writeAsBytes(screenshot);
                                // Ensure the file has been created and contains data
                                if (await imageFile.exists()) {
                                  try {
                                    // Reference to your Firebase Storage location
                                    var imagesRef = FirebaseStorage.instance
                                        .ref()
                                        .child('images/$username$runsDone.png');

                                    // Upload the file
                                    await imagesRef.putFile(imageFile);
                                    debugPrint(
                                        'Screenshot uploaded successfully');
                                  } catch (e) {
                                    debugPrint(
                                        'Error uploading screenshot: $e');
                                  }
                                } else {
                                  debugPrint(
                                      'Failed to save screenshot to file.');
                                }
                              }

                              // add run to database
                              Repository.addRun(
                                "runs",
                                Run(
                                  id: "",
                                  name: "Run",
                                  description: "Run",
                                  distance: distance.toStringAsFixed(2),
                                  time: StopWatchTimer.getDisplayTime(time,
                                      hours: false),
                                  date: DateTime.now().toString(),
                                  polylinePoints:
                                      MapLineDrawer.polylineCoordinates,
                                ),
                              );

                              //update stats
                              Repository.incrementRuns();
                              Repository.incrementTotalDistanceRan(distance);
                              Repository.incrementTotalTimeRan(time);
                              double totalPoints =
                                  distance / (time / 60000) * 10;
                              Repository.addPoints(totalPoints.toInt());

                              // update and display achievements
                              List<String> newAchievements =
                                  await Repository.updateUserAchievements(
                                      distance, time);

                              if (newAchievements.isNotEmpty) {
                                // Show dialog with the list of new achievements
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          "New achievements earned:"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: newAchievements
                                              .map((achievement) =>
                                                  Text(achievement))
                                              .toList(),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Yay!'),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              // stop location tracking and reset dist
                              LocationService.reset();

                              // reset timer
                              _stopWatchTimer.onResetTimer();

                              // set boolean to false
                              ref.read(timerProvider.notifier).startStopTimer();
                            },
                            child: const Text("Stop Run"),
                          ),
                        ),

                        // HIDE BUTTON
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(paddingValue / 4),
                                ),
                              ),
                            ),
                            onPressed: () {
                              // Pause Stopwatch
                              _stopWatchTimer.onStopTimer();
                              // Pause Location Tracking
                              LocationService.pauseLocationTracking();
                              // Show a new page of current stats
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PausedPage(
                                    stopWatchTimer: _stopWatchTimer,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Pause"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FilledButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(paddingValue / 4),
                                ),
                              ),
                            ),
                            onPressed: () {
                              ref
                                  .read(runDetailsProvider.notifier)
                                  .showHideRunDetails();
                            },
                            child: const Text("Hide Details"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
