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
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          // Profile hero
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: const ProfileHero(),
          ),

          Divider(
            indent: 20,
            endIndent: 20,
            color: Colors.black.withOpacity(0.2),
          ),

          // Profile details
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ProfileDetails(),
          ),

          Divider(
            indent: 20,
            endIndent: 20,
            color: Colors.black.withOpacity(0.2),
          ),

          // Profile actions/settings
          const ProfileSettings()
        ]),
      ),
    );
  }
}
