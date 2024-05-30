import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/achievements.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_details.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/run_achievement_button.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/runs_logged.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/chosen_state.dart';
import 'package:runningapp/state/backend/authenticator.dart';
import 'profile_widgets/profile_hero.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          IconButton(
              onPressed: Authenticator().logOut, icon: const Icon(Icons.logout))
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

          // Button to alternate run or achievement section
          const RunAchievementButton(),

          // Run or Achievement section
          // ignore: avoid_types_as_parameter_names
          Consumer(builder: (context, ref, child) {
            return ref.watch(selectedIndexProvider) == 0
                ? const AchievementsSection()
                : const RunsSection();
          })
        ]),
      ),
    );
  }
}
