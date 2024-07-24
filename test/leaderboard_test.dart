import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:provider/provider.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/leaderboards_page/leaderboards_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

@GenerateNiceMocks([MockSpec<Repository>()])
import 'leaderboard_test.mocks.dart';

void main() {
  late MockRepository mockRepository;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    HttpOverrides.global = null;
    mockRepository = MockRepository();
    mockFirebaseAuth =
        MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: "1"));
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: Provider<Repository>.value(
        value: mockRepository,
        child: StreamProvider<auth.User?>.value(
          value: mockFirebaseAuth.authStateChanges(),
          initialData: mockFirebaseAuth.currentUser,
          child: child,
        ),
      ),
    );
  }

  testWidgets(
      'LeaderboardsPage initializes and displays CircularProgressIndicator while loading',
      (WidgetTester tester) async {
    when(mockRepository.fetchTopUsersGlobal()).thenAnswer((_) async => []);
    when(mockRepository.fetchTopUsersFriends()).thenAnswer((_) async => []);

    await tester.pumpWidget(createTestWidget(LeaderboardsPage(
      repository: mockRepository,
      auth: mockFirebaseAuth,
    )));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets(
      'LeaderboardsPage displays data when Future completes successfully',
      (WidgetTester tester) async {
    when(mockRepository.fetchTopUsersGlobal()).thenAnswer((_) async => [
          {"uid": "1", "name": "User 1", "username": "user1", "points": 100},
          {"uid": "2", "name": "User 2", "username": "user2", "points": 90},
          {"uid": "3", "name": "User 3", "username": "user3", "points": 80},
        ]);
    when(mockRepository.fetchTopUsersFriends()).thenAnswer((_) async => []);
    await tester.pumpWidget(createTestWidget(LeaderboardsPage(
      repository: mockRepository,
      auth: mockFirebaseAuth,
    )));
    await tester.pumpAndSettle();

    expect(find.byType(LeaderboardCard), findsWidgets);
  });

  // Additional tests for navigation and interaction can be added here
}
