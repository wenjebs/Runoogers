import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/pages/login_and_registration/basic_onboarding_page.dart';

import 'login_or_register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // logged in
            debugPrint(snapshot.data.toString());
            if (snapshot.data != null) {
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
                    return onboarded
                        ? const HomePage()
                        : const OnboardingPage();
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
