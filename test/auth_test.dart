import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runningapp/pages/login_and_registration/components/auth_buttons.dart';
import 'package:runningapp/pages/login_and_registration/components/auth_textfields.dart';
import 'package:runningapp/pages/login_and_registration/components/login_tiles.dart';
import 'package:runningapp/pages/login_and_registration/forgot_password.dart';
import 'package:runningapp/pages/login_and_registration/login_page.dart';
import 'package:runningapp/pages/login_and_registration/register_page.dart';

void main() {
  // setUpAll(() async {});
  group("Login page tests", () {
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

    testWidgets('Invalid email test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(onTap: () {}),
      ));

      // Render the Login component
      expect(find.byType(LoginPage), findsOneWidget);

      // Enter an invalid email address in the email input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Email"),
          'invalid_email');

      // Enter an invalid password in the password input field
      // await tester.enterText(find.byKey(Key('passwordField')), '123');

      // Click the sign-in button
      await tester.tap(find.byType(MyButton));
      // Rebuild the widget with the new state
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is AlertDialog &&
                widget.content
                    .toString()
                    .contains("Please enter a valid email address"),
          ),
          findsOneWidget); // Check if an AlertDialog is shown
    });

    testWidgets('No password test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(onTap: () {}),
      ));

      // Render the Login component
      expect(find.byType(LoginPage), findsOneWidget);

      // Enter an a valid email address in the email input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Email"),
          'valid@gmail.com');

      // Enter an empty password in the password input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Password"),
          '');

      // Click the sign-in button
      await tester.tap(find.byType(MyButton));
      // Rebuild the widget with the new state
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is AlertDialog &&
                widget.content.toString().contains("Please enter a password"),
          ),
          findsOneWidget); // Check if an AlertDialog is shown
    });

    testWidgets('Valid email but wrong password test',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(onTap: () {}),
      ));

      // Render the Login component
      expect(find.byType(LoginPage), findsOneWidget);

      // Enter an invalid email address in the email input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Email"),
          'test@gmail.com');

      // Enter an invalid password in the password input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Password"),
          '123');

      // Click the sign-in button
      await tester.tap(find.byType(MyButton));
      // Rebuild the widget with the new state
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is AlertDialog &&
                widget.content
                    .toString()
                    .contains("The email address or password is not valid"),
          ),
          findsOneWidget); // Check if an AlertDialog is shown
    });

    testWidgets('Valid email but not registered', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(onTap: () {}),
      ));

      // Render the Login component
      expect(find.byType(LoginPage), findsOneWidget);

      // Enter an invalid email address in the email input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Email"),
          'invalid_email');

      // Enter an invalid password in the password input field
      // await tester.enterText(find.byKey(Key('passwordField')), '123');

      // Click the sign-in button
      await tester.tap(find.byType(MyButton));
      // Rebuild the widget with the new state
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is AlertDialog &&
                widget.content
                    .toString()
                    .contains("The email address or password is not valid"),
          ),
          findsOneWidget); // Check if an AlertDialog is shown
    });

    testWidgets('Google sign in works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(onTap: () {}),
      ));
    });
    testWidgets('Forget password button redirects to forgot password page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(onTap: () {}),
      ));

      // Check for the presence of the forget password button
      expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is InkWell && widget.key == const Key('forgotPassword'),
          ),
          findsOneWidget);

      // Tap the register button
      await tester.tap(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is InkWell && widget.key == const Key('forgotPassword'),
        ),
      );
      await tester.pumpAndSettle();

      // Check if the Forgot Password page is shown after tapping the register button
      expect(find.byType(ForgotPassword), findsOneWidget);
    });

    testWidgets('Register button redirects to register page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(onTap: () {}),
      ));

      // Tap the register button
      await tester.tap(find.byKey(const Key("registerNow")));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 1));
      // Check if the Register page is shown after tapping the register button
      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });

  group("Register page tests", () {
    testWidgets('Welcome text is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      // Check for the welcome text
      expect(find.text('Join Runoogers today, it\'s Free.'), findsOneWidget);
    });

    testWidgets('Email textfield is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      // Check for the email textfield
      expect(find.widgetWithText(AuthTextField, 'Email'), findsOneWidget);
    });

    testWidgets('Password textfield is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      // Check for the password textfield
      expect(find.widgetWithText(AuthTextField, 'Password'), findsOneWidget);
    });

    testWidgets('Confirm password textfield is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      // Check for the confirm password textfield
      expect(find.widgetWithText(AuthTextField, 'Confirm Password'),
          findsOneWidget);
    });
  });
}
