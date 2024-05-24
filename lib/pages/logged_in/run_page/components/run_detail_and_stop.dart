import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/run_page/completed_run_details_page.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: paddingValue, vertical: paddingValue / 2),
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
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  letterSpacing: 0,
                ),
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
                            StopWatchTimer.getDisplayTime(value, hours: false);
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
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '6 : 00 MIN/KM', // TODO DONT HARDCODE THIS
              ),
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
              ),
            ),
            const Divider(
              indent: 40,
              endIndent: 40,
            ),
            FilledButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(paddingValue / 4),
                  ),
                ),
              ),
              onPressed: () {
                // stop timer
                _stopWatchTimer.onStopTimer();

                // get the time
                final int time = _stopWatchTimer.rawTime.value;

                // get distance travelled
                final double distance = LocationService.distanceTravelled;

                // get pace of run

                // show run page
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

                // stop location tracking and reset dist
                LocationService.reset();

                // reset timer
                _stopWatchTimer.onResetTimer();

                // set boolean to false
                ref.read(timerProvider.notifier).startStopTimer();
              },
              child: const Text("Stop Run"),
            ),
          ],
        ),
      ),
    );
  }
}
