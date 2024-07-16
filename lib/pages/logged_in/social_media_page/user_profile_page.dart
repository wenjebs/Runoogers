import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievements_feed.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_details.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/run_achievement_button.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/runs_logged.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_hero.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/chosen_state.dart';
import 'package:runningapp/pages/logged_in/profile_page/webtest.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future in initState
    _userFuture = Repository.getUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('User Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Assuming your User model has name and username attributes
            final user = snapshot.data!;
            return Center(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                // Profile hero
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const ProfileHero(),
                ),

                // Profile details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      ProfileDetails(name: user.name, username: user.username),
                ),
                const RunAchievementButton(),

                // Run or Achievement section
                Builder(builder: (context) {
                  final userId =
                      user.id; // Ensure user.id is accessible in the scope
                  return Consumer(builder: (context, ref, child) {
                    return ref.watch(selectedIndexProvider) == 0
                        ? AchievementsFeed(userId: userId)
                        : RunsSection(userId: userId);
                  });
                }),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const WebTest()), // TODO replace
                    );
                  },
                  child: const Text('3D Avatar Test'),
                ),
              ]),
            );
          } else {
            return const Center(child: Text('User not found'));
          }
        },
      ),
    );
  }
}
