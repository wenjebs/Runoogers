import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievements_feed.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_details.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/run_achievement_button.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/runs_logged.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/chosen_state.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/runs_provider.dart';
import 'package:runningapp/pages/logged_in/profile_page/webtest.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'profile_widgets/profile_hero.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInformationProvider).asData?.value;
    final runsSnapshot =
        ref.watch(getRunsProvider(FirebaseAuth.instance.currentUser!.uid));

    final name = userInfo?['name'] as String?;
    final username = userInfo?['username'] as String?;
    int runsCount = 0;

    if (runsSnapshot is AsyncData<QuerySnapshot<Object?>>) {
      runsCount = runsSnapshot.value.docs.length;
    } else {}
    final friendsCount = (userInfo?['friends'] as List?)?.length ?? 69;

    return Scaffold(
      body: Center(
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
            padding: const EdgeInsets.all(2.0),
            child: name != null && username != null
                ? ProfileDetails(name: name, username: username)
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$runsCount',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Text(
                        'Runs',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$friendsCount',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Text(
                        'Friends',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Button to alternate run or achievement section
          const RunAchievementButton(),

          // Run or Achievement section

          Consumer(builder: (context, ref, child) {
            return ref.watch(selectedIndexProvider) == 0
                ? AchievementsFeed(
                    repository: Repository(),
                  )
                : const RunsSection();
          }),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WebTest()), // TODO replace
              );
            },
            child: const Text('3D Avatar Test'),
          ),
        ]),
      ),
    );
  }
}
