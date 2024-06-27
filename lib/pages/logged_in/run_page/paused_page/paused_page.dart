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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Paused'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Distance: ${LocationService.distanceTravelled.toStringAsFixed(2)} KM',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Time: ${StopWatchTimer.getDisplayTime(_stopWatchTimer.rawTime.value, hours: false)}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Pace: ${((_stopWatchTimer.rawTime.value / 60000) / LocationService.distanceTravelled).toStringAsFixed(2)} min/km',
                  style: const TextStyle(fontSize: 20),
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
