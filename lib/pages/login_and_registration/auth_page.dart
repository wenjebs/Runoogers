import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/pages/login_and_registration/basic_onboarding_page.dart';

import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // logged in
            if (snapshot.hasData && snapshot.data != null) {
              final User? user = snapshot.data;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for the data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null) {
                      final onboarded = data['onboarded'] as bool?;
                      // Proceed based on the 'onboarded' flag
                      return onboarded != null && onboarded
                          ? const HomePage()
                          : const OnboardingPage();
                    }
                  }
                  // Loading or error state
                  return const HomePage();
                },
              );
            }
            // not logged in
            else {
              return const LoginOrRegisterPage();
            }
          }),
    );
  }
}
