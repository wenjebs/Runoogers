import 'package:flutter/material.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  void sentEmailPopup() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Password Reset Link Sent'),
            content: const Text(
                'A password reset link has been sent to your email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter your email to reset your password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Authenticator().sendPasswordResetLink(emailController.text);
                sentEmailPopup();
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
