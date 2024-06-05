import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/pages/login_and_registration/onboarding_page.dart';

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
            if (snapshot.hasData) {
              final user = snapshot.data;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final onboarded = data['onboarded'] as bool;
                    return onboarded ? const HomePage() : OnboardingPage();
                  }
                  // Loading or error state
                  return HomePage();
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
