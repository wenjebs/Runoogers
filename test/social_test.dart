import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/social_media_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';

@GenerateNiceMocks([MockSpec<Repository>(), MockSpec<GetUserPostService>()])
import 'social_test.mocks.dart';

void main() {
  group('SocialMediaPage Tests', () {
    late MockRepository mockRepository;
    late MockGetUserPostService mockGetUserPostService;

    setUp(() {
      mockRepository = MockRepository();
      mockGetUserPostService = MockGetUserPostService();
    });

    testWidgets('Widget renders correctly with AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: const [
          // Override providers here if any
        ],
        child: MaterialApp(
          home: SocialMediaPage(
            mockRepository,
            postService: mockGetUserPostService,
          ),
        ),
      ));

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
    });
  });
}
