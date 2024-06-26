import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'components/auth_buttons.dart';
import 'components/auth_textfields.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoaded = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
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
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Repository.addUser('users', {
          'email': emailController.text,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'posts': [],
          'friends': [],
          'onboarded': false,
          'trainingOnboarded': false,
        });
      } else {
        showErrorMessage("passwords dont match");
      }
      //remove loading circle after login
      // if (mounted) {
      Navigator.pop(context);
      // }
    } on FirebaseAuthException catch (e) {
      // if (mounted) {
      Navigator.pop(context);
      // }
      showErrorMessage(e.code);
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
            image: AssetImage("lib/images/running.jpg"),
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
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 10),

                    // confirm password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
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
                          onTap: widget.onTap,
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
}
