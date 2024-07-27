import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'components/auth_buttons.dart';
import 'components/auth_textfields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.repository, required this.auth});
  final Repository repository;
  final FirebaseAuth auth;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoaded = false;
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
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
    //loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      if (passwordController.text == "" || passwordController.text == "") {
        Navigator.pop(context);
        showErrorMessage("Please enter a password!");
      } else if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        widget.repository.addUser('users', {
          // REMEMBER TO UPDATE SIGNIN AFTER MODYIFYING THIS!
          'email': emailController.text,
          'uid': widget.auth.currentUser!.uid,
          'posts': [],
          'friends': [],
          'onboarded': false,
          'trainingOnboarded': false,
          'activePlan': false,
          'runstats': {
            'totalDistance': 0,
            'totalTime': 0,
            'totalRuns': 0,
            'fastestTime': 0,
            'longestDistance': 0,
          },
          'points': 0,
          'activeStory': "",
          'achievements': [],
        });
        // pop loading circle
        Navigator.pop(context);

        // pop register page
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        showErrorMessage("Passwords dont match!");
      }
      //remove loading circle after login
      // if (mounted) {

      // }
    } on FirebaseAuthException catch (e) {
      // if (mounted) {
      Navigator.pop(context);
      // }
      showErrorMessage(getErrorMessage(e.code));
    }
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
          ),
        ),
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
                      size: 50,
                    ),

                    const SizedBox(height: 50),

                    // Welcome text
                    Text(
                      'Join Runoogers today, it\'s Free.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

                    // confirm password textfield
                    AuthTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      text: 'Sign Up',
                      onTap: signUserUp,
                    ),

                    const SizedBox(height: 50),

                    // or continue with
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Divider(
                    //           thickness: 0.5,
                    //           color: Colors.grey[400],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //         child: Text(
                    //           'Or continue with',
                    //           style: TextStyle(color: Colors.grey[700]),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Divider(
                    //           thickness: 0.5,
                    //           color: Colors.grey[400],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(height: 50),

                    // google + apple sign in buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: const [
                    //     // google button
                    //     SquareTile(imagePath: 'lib/images/google.png'),

                    //     SizedBox(width: 25),

                    //     // apple button
                    //     SquareTile(imagePath: 'lib/images/apple.png')
                    //   ],
                    // ),

                    const SizedBox(height: 50),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Login now',
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
}
