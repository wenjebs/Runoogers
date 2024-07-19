import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:runningapp/pages/login_and_registration/components/auth_buttons.dart';
import 'package:runningapp/pages/login_and_registration/components/auth_textfields.dart';
import 'package:runningapp/pages/login_and_registration/components/login_tiles.dart';
import 'package:runningapp/pages/login_and_registration/forgot_password.dart';
import 'package:runningapp/pages/login_and_registration/login_page.dart';
import 'package:runningapp/pages/login_and_registration/register_page.dart';
import 'package:runningapp/state/backend/authenticator.dart';

@GenerateNiceMocks([MockSpec<Authenticator>()])
import 'auth_test.mocks.dart';

void main() {
  group("Login page tests", () {
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
    mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'bob@somedomain.com', password: '123');
    final authenticator = MockAuthenticator();
    when(authenticator.userId).thenReturn('123');
    when(authenticator.isAlreadyLoggedIn).thenReturn(true);
    when(authenticator.displayName).thenReturn('John Doe');
    when(authenticator.loginWithEmailAndPassword("bob@somedomain.com", "123"))
        .thenAnswer((_) async {
      final UserCredential result =
          await mockFirebaseAuth.signInWithEmailAndPassword(
              email: "bob@somedomain.com", password: "123");
    });
    when(authenticator.loginWithEmailAndPassword("test@gmail.com", "123"))
        .thenAnswer((_) async {
      throw FirebaseAuthException(
        code: 'invalid-credential',
      );
    });
    when(authenticator.authStateChanges).thenAnswer((_) {
      return mockFirebaseAuth.authStateChanges();
    });
    when(authenticator.loginWithEmailAndPassword("test@gmail.com", "123"))
        .thenAnswer((_) async {
      throw FirebaseAuthException(
        code: 'invalid-credential',
      );
    });
    when(authenticator.loginWithEmailAndPassword("hehe@gmail.com", "123"))
        .thenAnswer((_) async {
      throw FirebaseAuthException(
        code: 'invalid-credential',
      );
    });
    when(authenticator.loginWithGoogle() as Future<void>).thenAnswer((_) async {
      return;
    });
    when(authenticator.loginWithFacebook() as Future<void>)
        .thenAnswer((_) async {
      return;
    });
    testWidgets('Login page renders correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: LoginPage(
        authenticator: authenticator,
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
        home: LoginPage(
          authenticator: authenticator,
        ),
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
        home: LoginPage(
          authenticator: authenticator,
        ),
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
        home: LoginPage(
          authenticator: authenticator,
        ),
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
      final AlertDialog test = tester.widget(find.byType(AlertDialog));
      final Center center = test.title as Center;
      final Text text = center.child as Text;
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is AlertDialog &&
              text.data == 'The email address or password is not valid.'),
          findsOneWidget); // Check if an AlertDialog is shown
    });

    testWidgets('Valid email but not registered', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(
          authenticator: authenticator,
        ),
      ));

      // Render the Login component
      expect(find.byType(LoginPage), findsOneWidget);

      // Enter an invalid email address in the email input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Email"),
          'hehe@gmail.com');

      // Enter an invalid password in the password input field
      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is AuthTextField && widget.hintText == "Password"),
          '123');

      // Click the sign-in button
      await tester.tap(find.byType(MyButton));
      // Rebuild the widget with the new state
      await tester.pumpAndSettle();
      // Check if an AlertDialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);

      // If AlertDialog is present, then access its properties
      if (find.byType(AlertDialog).evaluate().isNotEmpty) {
        final AlertDialog alertDialog = tester.widget(find.byType(AlertDialog));
        final Center center = alertDialog.title as Center;
        final Text text = center.child as Text;
        debugPrint(text.data.toString());
        expect(text.data, 'The email address or password is not valid.');
      }
    });

    testWidgets('Forget password button redirects to forgot password page',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(
          authenticator: authenticator,
        ),
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

    // testWidgets('Sign in redirects to homepage', (WidgetTester tester) async {
    //   await tester.pumpWidget(MaterialApp(
    //     home: LoginPage(
    //       authenticator: authenticator,
    //     ),
    //   ));

    //   // Enter a valid email address in the email input field
    //   await tester.enterText(
    //       find.byWidgetPredicate((Widget widget) =>
    //           widget is AuthTextField && widget.hintText == "Email"),
    //       'bob@somedomain.com');

    //   // Enter a valid password in the password input field
    //   await tester.enterText(
    //       find.byWidgetPredicate((Widget widget) =>
    //           widget is AuthTextField && widget.hintText == "Password"),
    //       '123');

    //   // Click the sign-in button
    //   await tester.tap(find.byType(MyButton));
    //   // Rebuild the widget with the new state
    //   await tester.pumpAndSettle();
    //   await tester.pumpWidget(
    //       MaterialApp(home: AuthPage(authenticator: authenticator)));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(HomePage), findsOneWidget);
    // });
    // testWidgets('Register button redirects to register page',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(MaterialApp(
    //     home: LoginPage(
    //       authenticator: authenticator,
    //     ),
    //   ));

    //   // Tap the register button
    //   await tester.tap(
    //     find.byWidgetPredicate(
    //       (Widget widget) =>
    //           widget is GestureDetector &&
    //           widget.key == const Key('registerNow'),
    //     ),
    //   );
    //   await tester.pumpAndSettle();

    //   // await tester.pump(const Duration(seconds: 5));
    //   // Check if the Register page is shown after tapping the register button
    //   expect(find.byType(RegisterPage), findsOneWidget);
    // });
  });

  group("Register page tests", () {
    testWidgets('Welcome text is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      // Check for the welcome text
      expect(find.text('Join Runoogers today, it\'s Free.'), findsOneWidget);
    });

    testWidgets('Email textfield is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      // Check for the email textfield
      expect(find.widgetWithText(AuthTextField, 'Email'), findsOneWidget);
    });

    testWidgets('Password textfield is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      // Check for the password textfield
      expect(find.widgetWithText(AuthTextField, 'Password'), findsOneWidget);
    });

    testWidgets('Confirm password textfield is rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      // Check for the confirm password textfield
      expect(find.widgetWithText(AuthTextField, 'Confirm Password'),
          findsOneWidget);
    });
  });
}
