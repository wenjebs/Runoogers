import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runningapp/pages/logged_in/story_page/active_quest_display_page.dart';
import 'package:runningapp/pages/logged_in/story_page/models/story_model.dart';
import 'package:runningapp/pages/logged_in/story_page/story_page.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/quests_model.dart';

@GenerateNiceMocks([MockSpec<Repository>()])
import 'story_test.mocks.dart';

void main() {
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
  });

  group("Story page tests", () {
    testWidgets(
        'StoryPage initializes and displays CircularProgressIndicator while loading',
        (WidgetTester tester) async {
      when(mockRepository.getStories()).thenAnswer((_) async =>
          <Story>[]); // Replace <Quest>[] with actual list of Quests
      await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: StoryPage(mockRepository))));
      expect(find.text("Main Campaigns"), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // testWidgets('StoryPage displays data when Future completes successfully',
    //     (WidgetTester tester) async {
    //   // when(mockRepository.getStories()).thenAnswer(
    //   //     (_) async => <Quest>[]); // Replace <Quest>[] with actual list of Quests
    //   await tester.pumpWidget(
    //       ProviderScope(child: MaterialApp(home: StoryPage(mockRepository))));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(ListView), findsWidgets);
    // });

    // testWidgets(
    //     'StoryPage displays error message when Future completes with error',
    //     (WidgetTester tester) async {
    //   // when(mockRepository.getStories())
    //   //     .thenAnswer((_) async => throw Exception('Error fetching data'));
    //   await tester.pumpWidget(
    //       ProviderScope(child: MaterialApp(home: StoryPage(mockRepository))));
    //   await tester.pumpAndSettle();
    //   expect(
    //       find.text('Error: Exception: Error fetching data'), findsOneWidget);
    // });

    // testWidgets(
    //     'Tapping on "Active Quests" navigates to ActiveQuestDisplayPage',
    //     (WidgetTester tester) async {
    //   // when(mockRepository.getStories()).thenAnswer(
    //   //     (_) async => <Quest>[]); // Replace <Quest>[] with actual list of Quests
    //   await tester.pumpWidget(
    //       ProviderScope(child: MaterialApp(home: StoryPage(mockRepository))));
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.byType(ElevatedButton));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(ActiveQuestDisplayPage), findsOneWidget);
    // });
  });
}
