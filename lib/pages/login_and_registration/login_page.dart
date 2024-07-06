import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runningapp/pages/login_and_registration/components/login_tiles.dart';
import 'package:runningapp/pages/login_and_registration/forgot_password.dart';
import 'components/auth_buttons.dart';
import 'components/auth_textfields.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  void signUserIn() async {
    // Check if the email matches the regex pattern
    if (!emailRegex.hasMatch(emailController.text)) {
      // If the email format is invalid, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Email'),
            content: const Text('Please enter a valid email address.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Do not proceed with the sign-in process
    }

    if (passwordController.text.isEmpty) {
      // If the email format is invalid, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No password!'),
            content: const Text('Please enter a password'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Do not proceed with the sign-in process
    }

    //loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the load circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the load circle
      Navigator.pop(context);
      // show error message
      String message = getErrorMessage(e.code);
      showErrorMessage(message);
    } on PlatformException catch (e) {
      // pop the load circle
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.message!);
      // print("sike im here");
    }
  }

  String getErrorMessage(String errorCode) {
    String errorMessage;

    switch (errorCode) {
      case 'invalid-credential':
        errorMessage = 'The email address or password is not valid.';
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
      case 'user-disabled':
        errorMessage = 'This user has been disabled.';
      case 'user-not-found':
        errorMessage = 'No user found with this email.';
      case 'wrong-password':
        errorMessage = 'Wrong password provided.';
      case 'network-request-failed':
        errorMessage = 'Check your internet connection and try again.';
      default:
        errorMessage = 'An unexpected error occurred. Please try again.';
    }

    return errorMessage;
  }

  // error message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("lib/assets/images/running.jpg"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.8),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // logo
                    const Icon(
                      Icons.directions_run,
                      size: 100,
                    ),

                    const SizedBox(height: 50),

                    // welcome back, you've been missed!
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // email textfield
                    AuthTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    AuthTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              debugPrint("forgot password");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      onTap: signUserIn,
                    ),

                    const SizedBox(height: 50),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // google + apple sign in buttons
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // google button
                        SquareTile(imagePath: 'lib/assets/images/google.png'),

                        SizedBox(width: 25),

                        // apple button
                        SquareTile(imagePath: 'lib/assets/images/apple.png')
                      ],
                    ),

                    const SizedBox(height: 50),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
