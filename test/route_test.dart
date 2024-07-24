import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/route_model.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_view.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_details_page.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'route_test.mocks.dart';

void main() {
  late MockRepository mockRepository;

  setUpAll(() {
    mockRepository = MockRepository();
    HttpOverrides.global = null;
  });
  group("Route page tests", () {
    testWidgets('RoutesView shows CircularProgressIndicator while loading',
        (WidgetTester tester) async {
      when(mockRepository.getSavedRoutes())
          .thenAnswer((_) async => Future.value(<RouteModel>[]));
      await tester.pumpWidget(
        ProviderScope(
          overrides: const [],
          child: MaterialApp(
            home: RoutesView(repository: mockRepository),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('RoutesView shows no routes message when no routes are saved',
        (WidgetTester tester) async {
      when(mockRepository.getSavedRoutes())
          .thenAnswer((_) async => Future.value(<RouteModel>[]));
      await tester.pumpWidget(
        ProviderScope(
          overrides: const [],
          child: MaterialApp(
            home: RoutesView(repository: mockRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("No routes saved yet."), findsOneWidget);
    });

    testWidgets('RoutesView correctly displays routes',
        (WidgetTester tester) async {
      when(mockRepository.getSavedRoutes())
          .thenAnswer((_) async => Future.value(<RouteModel>[
                RouteModel(
                  description: "Route 1",
                  id: "1",
                  name: "Route 1",
                  distance: "2",
                  polylinePoints: {},
                  imageUrl: "",
                ),
              ]));
      await tester.pumpWidget(
        ProviderScope(
          overrides: const [],
          child: MaterialApp(
            home: RoutesView(repository: mockRepository),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets(
      'Click onto route page correctly navigates to route details page',
      (WidgetTester tester) async {
        when(mockRepository.getSavedRoutes()).thenAnswer(
          (_) async => Future.value(
            <RouteModel>[
              RouteModel(
                description: "Route 1",
                id: "1",
                name: "Route 1",
                distance: "2",
                polylinePoints: {
                  const LatLng(0, 0),
                },
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/runoogers.appspot.com/o/story%2FIVAN.png?alt=media&token=2d7b9a97-44e0-4abe-b664-2540b3b9451b",
              ),
            ],
          ),
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: const [],
            child: MaterialApp(
              home: RoutesView(repository: mockRepository),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(
          find.byWidgetPredicate(
              (Widget widget) => widget is InkWell && widget.child is Padding),
        );

        await tester.pumpAndSettle();

        expect(find.byType(RoutesDetailsPage), findsOneWidget);
      },
    );

    testWidgets(
      'Route details page renders correctly',
      (WidgetTester tester) async {
        when(mockRepository.getSavedRoutes()).thenAnswer(
          (_) async => Future.value(
            <RouteModel>[
              RouteModel(
                description: "Route 1",
                id: "1",
                name: "Route 1",
                distance: "2",
                polylinePoints: {
                  const LatLng(0, 0),
                },
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/runoogers.appspot.com/o/story%2FIVAN.png?alt=media&token=2d7b9a97-44e0-4abe-b664-2540b3b9451b",
              ),
            ],
          ),
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: const [],
            child: MaterialApp(
              home: RoutesView(repository: mockRepository),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(ListView), findsOneWidget);

        await tester.tap(
          find.byWidgetPredicate(
              (Widget widget) => widget is InkWell && widget.child is Padding),
        );

        await tester.pumpAndSettle();

        expect(find.byType(RoutesDetailsPage), findsOneWidget);

        expect(find.byType(GoogleMap), findsAny);
      },
    );

    testWidgets(
      'RoutesView shows alertdialog when generate route is pressed',
      (WidgetTester tester) async {
        when(mockRepository.getSavedRoutes())
            .thenAnswer((_) async => Future.value(<RouteModel>[]));
        await tester.pumpWidget(
          ProviderScope(
            overrides: const [],
            child: MaterialApp(
              home: RoutesView(repository: mockRepository),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));

        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
      },
    );

    testWidgets(
      'Route generation alert dialog shows two options',
      (WidgetTester tester) async {
        when(mockRepository.getSavedRoutes())
            .thenAnswer((_) async => Future.value(<RouteModel>[]));
        await tester.pumpWidget(
          ProviderScope(
            overrides: const [],
            child: MaterialApp(
              home: RoutesView(repository: mockRepository),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));

        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        expect(find.byType(ElevatedButton), findsNWidgets(2));
      },
    );
  });
}
