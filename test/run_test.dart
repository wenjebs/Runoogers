import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runningapp/pages/logged_in/run_page/components/run_detail_and_stop.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/loading_map.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';
import 'package:runningapp/database/repository.dart';

// Mock classes
@GenerateNiceMocks([MockSpec<Repository>(), MockSpec<LocationService>()])
import 'run_test.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late MockLocationService mockLocationService;

  setUp(() {
    mockRepository = MockRepository();
    mockLocationService = MockLocationService();
    // Setup mock responses
    // Example: when(mockLocationService.checkPermission()).thenAnswer((_) async => PermissionStatus.granted);
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [],
      child: MaterialApp(home: child),
    );
  }

  group('RunPage Tests', () {
    testWidgets('Display disabled location when no location permission',
        (WidgetTester tester) async {
      when(mockLocationService.locationServiceEnabled).thenAnswer((_) => false);
      await tester.pumpWidget(
        createTestWidget(
          RunPage(
            locationService: mockLocationService,
            repository: mockRepository,
            storyRun: false,
            title: 'Test Run',
          ),
        ),
      );
      // Check if map loading
      expect(find.byType(DisabledLocationWidget), findsOneWidget);
    });
    testWidgets(
        'Show loading map when  location permission granted but no current position',
        (WidgetTester tester) async {
      when(mockLocationService.locationServiceEnabled).thenAnswer((_) => true);
      await tester.pumpWidget(
        createTestWidget(
          RunPage(
            locationService: mockLocationService,
            repository: mockRepository,
            storyRun: false,
            title: 'Test Run',
          ),
        ),
      );
      // Check if map loading
      expect(find.byType(LoadingMap), findsOneWidget);
    });

    testWidgets(
        'Show map when location permission granted and current position loaded',
        (WidgetTester tester) async {
      when(mockLocationService.locationServiceEnabled).thenAnswer((_) => true);
      when(mockLocationService.currentPosition).thenAnswer((_) => Position(
            latitude: 1.0,
            longitude: 1.0,
            timestamp: DateTime.now(),
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 1.0,
            speedAccuracy: 1.0,
            altitudeAccuracy: 1.0,
            headingAccuracy: 1.0,
          ));
      await tester.pumpWidget(
        createTestWidget(
          RunPage(
            locationService: mockLocationService,
            repository: mockRepository,
            storyRun: false,
            title: 'Test Run',
            currPos: mockLocationService.currentPosition,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GoogleMap), findsOneWidget);
    });
    testWidgets('no internet test', (WidgetTester tester) async {
      when(mockLocationService.locationServiceEnabled).thenAnswer((_) => true);
      when(mockLocationService.connectivity)
          .thenAnswer((_) => [ConnectivityResult.none]);
      await tester.pumpWidget(
        createTestWidget(
          RunPage(
            locationService: mockLocationService,
            repository: mockRepository,
            storyRun: false,
            title: 'Test Run',
          ),
        ),
      );
      // Check if map loading
      expect(find.text("NO internet!"), findsOneWidget);
    });

    testWidgets('Start Functionality Test', (WidgetTester tester) async {
      // Simulate starting and stopping the run and verify the state changes and UI updates
      when(mockLocationService.locationServiceEnabled).thenAnswer((_) => true);
      when(mockLocationService.currentPosition).thenAnswer((_) => Position(
            latitude: 1.0,
            longitude: 1.0,
            timestamp: DateTime.now(),
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 1.0,
            speedAccuracy: 1.0,
            altitudeAccuracy: 1.0,
            headingAccuracy: 1.0,
          ));
      await tester.pumpWidget(
        createTestWidget(
          RunPage(
            locationService: mockLocationService,
            repository: mockRepository,
            storyRun: false,
            title: 'Test Run',
            currPos: mockLocationService.currentPosition,
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Check if map is displayed
      expect(find.byType(GoogleMap), findsOneWidget);
      // Check if start button is displayed
      expect(find.byKey(const Key('startButton')), findsOneWidget);
      // Tap start button
      await tester.tap(find.byKey(const Key('startButton')));
      await tester.pumpAndSettle();
      // Check if while run widget is displayed
      expect(find.byType(RunDetailsAndStop), findsOneWidget);
    });
    testWidgets('Stop Functionality Test when not moved',
        (WidgetTester tester) async {
      // Simulate starting and stopping the run and verify the state changes and UI updates
      when(mockLocationService.locationServiceEnabled).thenAnswer((_) => true);
      when(mockLocationService.currentPosition).thenAnswer((_) => Position(
            latitude: 1.0,
            longitude: 1.0,
            timestamp: DateTime.now(),
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 1.0,
            speedAccuracy: 1.0,
            altitudeAccuracy: 1.0,
            headingAccuracy: 1.0,
          ));
      await tester.pumpWidget(
        createTestWidget(
          RunPage(
            locationService: mockLocationService,
            repository: mockRepository,
            storyRun: false,
            title: 'Test Run',
            currPos: mockLocationService.currentPosition,
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Check if map is displayed
      expect(find.byType(GoogleMap), findsOneWidget);
      // Check if start button is displayed
      expect(find.byKey(const Key('startButton')), findsOneWidget);
      // Tap start button
      await tester.tap(find.byKey(const Key('startButton')));
      await tester.pumpAndSettle();
      // Check if while run widget is displayed
      expect(find.byType(RunDetailsAndStop), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('stopRunButton')));

      await tester.pumpAndSettle();

      // Check for alertdialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('You have not moved!'), findsOneWidget);
    });
    testWidgets('Ask user if travelled less than 20m',
        (WidgetTester tester) async {
      // Simulate starting and stopping the run and verify the state changes and UI updates
      when(mockLocationService.distanceTravelled).thenAnswer((_) => 0.01);
      when(mockLocationService.locationServiceEnabled).thenAnswer((_) => true);
      when(mockLocationService.currentPosition).thenAnswer((_) => Position(
            latitude: 1.0,
            longitude: 1.0,
            timestamp: DateTime.now(),
            accuracy: 1.0,
            altitude: 1.0,
            heading: 1.0,
            speed: 1.0,
            speedAccuracy: 1.0,
            altitudeAccuracy: 1.0,
            headingAccuracy: 1.0,
          ));
      await tester.pumpWidget(
        createTestWidget(
          RunPage(
            locationService: mockLocationService,
            repository: mockRepository,
            storyRun: false,
            title: 'Test Run',
            currPos: mockLocationService.currentPosition,
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Check if map is displayed
      expect(find.byType(GoogleMap), findsOneWidget);
      // Check if start button is displayed
      expect(find.byKey(const Key('startButton')), findsOneWidget);
      // Tap start button
      await tester.tap(find.byKey(const Key('startButton')));
      await tester.pumpAndSettle();
      // Check if while run widget is displayed
      expect(find.byType(RunDetailsAndStop), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('stopRunButton')));

      await tester.pumpAndSettle();

      // Check for alertdialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
    });
  });
}
