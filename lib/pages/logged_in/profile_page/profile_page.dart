import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievements_feed.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/avatar_creator.dart';
import 'package:runningapp/pages/logged_in/profile_page/inventory_page/inventory_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_details.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/run_achievement_button.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/runs_logged.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/chosen_state.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'profile_widgets/profile_hero.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInformationProvider).asData?.value;

    final name = userInfo?['name'] as String?;
    final username = userInfo?['username'] as String?;

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
            padding: const EdgeInsets.all(8.0),
            child: name != null && username != null
                ? ProfileDetails(name: name, username: username)
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
          ),

          // Button to alternate run or achievement section
          const RunAchievementButton(),

          // Run or Achievement section

          Consumer(builder: (context, ref, child) {
            return ref.watch(selectedIndexProvider) == 0
                ? const AchievementsFeed()
                : const RunsSection();
          }),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AvatarCreatorWidget()), // TODO replace
              );
            },
            child: const Text('3D Avatar Test'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InventoryPage(),
                ), // TODO replace
              );
            },
            child: const Text('Invetory'),
          ),
        ]),
      ),
    );
  }
}
