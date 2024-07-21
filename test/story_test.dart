import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/story_page/active_quest_display_page.dart';
import 'package:runningapp/pages/logged_in/story_page/models/story_model.dart';
import 'package:runningapp/pages/logged_in/story_page/story_page.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/story_page/story_tile_with_image.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'story_test.mocks.dart';

void main() {
  late MockRepository mockRepository;

  setUpAll(() {
    mockRepository = MockRepository();
    HttpOverrides.global = null;
  });

  group("Story page tests", () {
    testWidgets(
        'StoryPage initializes and displays CircularProgressIndicator while loading',
        (WidgetTester tester) async {
      when(mockRepository.getStories()).thenAnswer((_) async => <Story>[]);
      await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: StoryPage(mockRepository))));
      expect(find.text("Main Campaigns"), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('StoryPage displays data when Future completes successfully',
        (WidgetTester tester) async {
      when(mockRepository.getStories()).thenAnswer((_) async => <Story>[]);
      await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: StoryPage(mockRepository))));
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets(
        'StoryPage displays error message when Future completes with error',
        (WidgetTester tester) async {
      when(mockRepository.getStories())
          .thenAnswer((_) async => throw Exception('Error fetching data'));
      await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: StoryPage(mockRepository))));
      await tester.pumpAndSettle();
      expect(
          find.text('Error: Exception: Error fetching data'), findsOneWidget);
    });

    testWidgets('Tapping on a story navigates to story detail page',
        (WidgetTester tester) async {
      when(mockRepository.getStories()).thenAnswer((_) async => <Story>[
            Story(
                id: "1",
                shortTitle: "Test Story",
                title: "Test Story",
                description: "Test Description",
                imageURL:
                    "https://firebasestorage.googleapis.com/v0/b/runoogers.appspot.com/o/story%2FIVAN.png?alt=media&token=2d7b9a97-44e0-4abe-b664-2540b3b9451b",
                quests: [])
          ]);
      await tester.pumpWidget(ProviderScope(overrides: [
        userInformationProvider.overrideWith((ref) {
          return Stream.value({
            'uid': '123',
            'name': 'Test User',
            'email': "test@gmail.com",
          });
        })
      ], child: MaterialApp(home: StoryPage(mockRepository))));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(StoryTileWithImage));
      await tester.pumpAndSettle();
    });

    testWidgets('Story detail page renders correctly when navigated to',
        (WidgetTester tester) async {
      when(mockRepository.getStories()).thenAnswer((_) async => <Story>[
            Story(
                id: "1",
                shortTitle: "Test Story",
                title: "Test Story",
                description: "Test Description",
                imageURL:
                    "https://firebasestorage.googleapis.com/v0/b/runoogers.appspot.com/o/story%2FIVAN.png?alt=media&token=2d7b9a97-44e0-4abe-b664-2540b3b9451b",
                quests: [])
          ]);
      await tester.pumpWidget(ProviderScope(overrides: [
        userInformationProvider.overrideWith((ref) {
          return Stream.value({
            'uid': '123',
            'name': 'Test User',
            'email': "test@gmail.com",
          });
        })
      ], child: MaterialApp(home: StoryPage(mockRepository))));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(StoryTileWithImage));
      await tester.pumpAndSettle();

      expect(find.text("Test Story"), findsOneWidget);
      expect(find.text("Test Description"), findsOneWidget);
    });

    testWidgets(
        'Tapping on "Active Quests" navigates to ActiveQuestDisplayPage',
        (WidgetTester tester) async {
      when(mockRepository.getStories()).thenAnswer((_) async => <Story>[]);
      await tester.pumpWidget(ProviderScope(overrides: [
        userInformationProvider.overrideWith((ref) {
          return Stream.value({
            'uid': '123',
            'name': 'Test User',
            'email': "test@gmail.com",
            'activeStory': 'ivan',
          });
        })
      ], child: MaterialApp(home: StoryPage(mockRepository))));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(ActiveQuestDisplayPage), findsOneWidget);
    });
  });
}
