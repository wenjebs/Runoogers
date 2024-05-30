import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/achievements.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_details.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/run_achievement_button.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/test.dart';
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
        titleTextStyle:
            Theme.of(context).textTheme.titleLarge, // Need hot restart to see
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            // Add your button functionality here
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Text('Profile'),
        centerTitle: true,
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

          // Profile details
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ProfileDetails(),
          ),

          const RunAchievementButton(),

          // const AchievementsSection(),
          const RunsSection(),
          // Profile actions/settings
          // const ProfileSettings()
        ]),
      ),
    );
  }
}
