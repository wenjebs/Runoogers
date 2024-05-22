import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_widgets/profile_details.dart';
import 'profile_widgets/profile_hero.dart';
import 'profile_widgets/profile_settings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile hero
              ProfileHero(),

              // Profile details
              ProfileDetails(),

              // Profile actions/settings
              ProfileSettings()
            ]),
      ),
    );
  }
}
