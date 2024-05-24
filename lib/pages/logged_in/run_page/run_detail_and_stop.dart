import 'package:flutter/material.dart';
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
            const Divider(),
            const Text(
              'PACE',
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '6 : 00 MIN/KM',
              ),
            ),
            const Divider(),
            const Text(
              'DISTANCE',
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '0 KM',
              ),
            ),
            const Divider(),
            FilledButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(paddingValue / 4),
                  ),
                ),
              ),
              onPressed: () {
                // setState(() {
                //   // Stop timer.
                //   _stopWatchTimer.onStopTimer();
                //   // Reset timer
                //   _stopWatchTimer.onResetTimer();
                //   _isRunning = false;
                // });
                _stopWatchTimer.onStopTimer();
                _stopWatchTimer.onResetTimer();
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
