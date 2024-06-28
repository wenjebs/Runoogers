import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/draw_poly_line.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:runningapp/pages/logged_in/run_page/paused_page/paused_page.dart';
import 'package:runningapp/providers.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RunDetailsAndStop extends ConsumerWidget {
  const RunDetailsAndStop({
    super.key,
    required this.paddingValue,
    required StopWatchTimer stopWatchTimer,
    required this.context,
  }) : _stopWatchTimer = stopWatchTimer;

  final double paddingValue;
  final StopWatchTimer _stopWatchTimer;
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
                            onPressed: () {
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
                              Repository.incrementTotalDistanceRan(distance);
                              Repository.incrementTotalTimeRan(time);
                              Repository.updateUserAchievements(distance, time);

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
