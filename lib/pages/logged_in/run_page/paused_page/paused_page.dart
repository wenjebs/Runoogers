import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PausedPage extends StatelessWidget {
  const PausedPage({
    super.key,
    required StopWatchTimer stopWatchTimer,
  }) : _stopWatchTimer = stopWatchTimer;

  final StopWatchTimer _stopWatchTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paused'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              // Time taken so far
              children: <Widget>[
                Text(
                  'Time: ${StopWatchTimer.getDisplayTime(_stopWatchTimer.rawTime.value)}',
                ),
                // Distance travelled so far
                Text(
                  'Distance: ${LocationService.distanceTravelled} km',
                ),
                // Pace so far
                Text(
                  'Pace: ${(_stopWatchTimer.rawTime.value / 1000 / 60) / (LocationService.distanceTravelled)} min/km',
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Resume Stopwatch
                _stopWatchTimer.onStartTimer();

                // Resume tracking
                LocationService.resumeLocationTracking();

                Navigator.of(context).pop();
              },
              child: const Text('Resume'),
            ),
          ],
        ),
      ),
    );
  }
}
