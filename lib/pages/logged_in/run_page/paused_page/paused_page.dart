import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PausedPage extends StatelessWidget {
  final LocationService locationService;

  const PausedPage({
    super.key,
    required StopWatchTimer stopWatchTimer,
    required this.locationService,
  }) : _stopWatchTimer = stopWatchTimer;

  final StopWatchTimer _stopWatchTimer;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool isPaused) {
        // Resume Stopwatch
        _stopWatchTimer.onStartTimer();

        // Resume tracking
        LocationService.resumeLocationTracking();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('Run Paused'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  PausedTimeDisplay(stopWatchTimer: _stopWatchTimer),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PausedDistanceDisplay(locationService: locationService),
                      const SizedBox(
                        height: 100,
                        child: VerticalDivider(
                          thickness: 2,
                          color: Color.fromARGB(32, 0, 0, 0),
                        ),
                      ),
                      PausedPaceDisplay(
                        locationService: locationService,
                        stopWatchTimer: _stopWatchTimer,
                      ),
                    ],
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
      ),
    );
  }
}

class PausedPaceDisplay extends StatelessWidget {
  const PausedPaceDisplay({
    super.key,
    required this.locationService,
    required StopWatchTimer stopWatchTimer,
  }) : _stopWatchTimer = stopWatchTimer;

  final LocationService locationService;
  final StopWatchTimer _stopWatchTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Column(
        children: [
          const Text('Pace'),
          Text(
            '${locationService.distanceTravelled == 0 ? 0 : ((_stopWatchTimer.rawTime.value / 60000) / locationService.distanceTravelled).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 60),
          ),
          const Text('min/km'),
        ],
      ),
    );
  }
}

class PausedTimeDisplay extends StatelessWidget {
  const PausedTimeDisplay({
    super.key,
    required StopWatchTimer stopWatchTimer,
  }) : _stopWatchTimer = stopWatchTimer;

  final StopWatchTimer _stopWatchTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Time Elapsed',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            StopWatchTimer.getDisplayTime(_stopWatchTimer.rawTime.value,
                hours: true, minute: true, second: true, milliSecond: false),
            style: const TextStyle(fontSize: 60),
          ),
        ],
      ),
    );
  }
}

class PausedDistanceDisplay extends StatelessWidget {
  const PausedDistanceDisplay({
    super.key,
    required this.locationService,
  });

  final LocationService locationService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text('Distance'),
          Text(
            locationService.distanceTravelled.toStringAsFixed(2),
            style: const TextStyle(fontSize: 60),
          ),
          const Text('km'),
        ],
      ),
    );
  }
}
