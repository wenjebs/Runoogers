import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runningapp/pages/logged_in/run_stats_page/run_stats_page.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';

void main() {
  // Define test values
  final testSnapshot = {
    'fastestTime': '5:00',
    'totalTime': 10,
    'longestDistance': '10 km',
    'totalRuns': '5',
    'totalDistance': '50 km',
    'totalDistanceRan': 45.0,
    'points': '100',
  };
  group('RunStatsPage', () {
    testWidgets('RunStatsPage displays loading correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userInformationProvider.overrideWith((ref) {
              return Stream.value(testSnapshot);
            })
          ],
          child: const MaterialApp(home: RunStatsPage()),
        ),
      );

      // Check that it loads
      expect(find.byType(CircularProgressIndicator), findsAny);
    });

    testWidgets('RunStatsPage displays stats correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userInformationProvider.overrideWith((ref) {
              return Stream.value(testSnapshot);
            })
          ],
          child: const MaterialApp(home: RunStatsPage()),
        ),
      );

      // Check that it loads
      expect(find.byType(CircularProgressIndicator), findsAny);

      await tester.pumpAndSettle();

      // Check that the stats are displayed correctly
      expect(find.text('Total Runs'), findsOneWidget);
      expect(find.text('Total Time'), findsOneWidget);
      // Add checks for the rest of the stats similarly
    });

    testWidgets('RunStatsPage displays error when there is an error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userInformationProvider.overrideWith((ref) {
              return Stream.error(Error());
            })
          ],
          child: const MaterialApp(home: RunStatsPage()),
        ),
      );
      await tester.pumpAndSettle();
      // Check that it shows error
      expect(find.byKey(const Key("StatsError")), findsAny);
    });
  });
}
