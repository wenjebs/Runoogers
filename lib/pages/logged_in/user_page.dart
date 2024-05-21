import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Center(
          child: Text(
        "HOME PAGE HERE, LOGGED IN AS: ${user.email!}",
        style: const TextStyle(fontSize: 20),
      )),
    );
  }
}
