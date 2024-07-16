import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:runningapp/pages/login_and_registration/components/auth_buttons.dart';
import 'package:runningapp/pages/login_and_registration/components/auth_textfields.dart';
import 'package:runningapp/pages/login_and_registration/components/login_tiles.dart';
import 'package:runningapp/pages/login_and_registration/login_page.dart';
import 'package:runningapp/pages/login_and_registration/register_page.dart';
import 'package:runningapp/state/backend/authenticator.dart'; // Replace with your actual import

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  setUpAll(() async {});

  testWidgets('Login page renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: LoginPage(
      onTap: () {},
    )));

    // Check for a specific widget that would only be found on the Auth page.
    // For example, looking for a Text widget containing 'Login'
    expect(find.text('Welcome back!'), findsOneWidget);

    // You can also check for other elements like TextFields, Buttons, etc.
    expect(find.byType(AuthTextField), findsWidgets);
    expect(find.byType(SquareTile), findsWidgets);
    // Add more checks as necessary to confirm the page renders as expected
  });

  // testWidgets('Register page renders correctly', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MaterialApp(
  //       home: RegisterPage(
  //     onTap: () {},
  //   )));
  //   // Check for a specific widget that would only be found on the register page
  //   expect(find.text('Join Runoogers today, it\'s Free.'), findsOneWidget);

  //   // Check for the presence of AuthTextFields for entering user details
  //   expect(find.byType(AuthTextField), findsWidgets);

  //   // Check for the presence of a registration button
  //   expect(find.byType(MyButton), findsOneWidget);
  // });
}
