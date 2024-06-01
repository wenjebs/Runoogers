import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runningapp/components/side_drawer.dart';
import 'package:runningapp/pages/logged_in/leaderboards_page/leaderboards_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/run_stats_page/run_stats_page.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';
import 'package:runningapp/pages/logged_in/settings_page/settings_page.dart';
import 'package:runningapp/pages/logged_in/social_page.dart';
import 'package:runningapp/pages/logged_in/story_page/story_page.dart';
import 'package:runningapp/pages/logged_in/training_page/training_page.dart';
import 'package:runningapp/pages/logged_in/user_page.dart';
import 'package:runningapp/providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const UserPage(),
    const RunPage(),
    const SocialPage(),
    const ProfilePage(),
    const StoryPage(),
    const TrainingPage(),
    const RunStatsPage(),
    const LeaderboardsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? "Home"
              : _selectedIndex == 1
                  ? "Run"
                  : _selectedIndex == 2
                      ? "Social"
                      : "Profile",
        ),
        backgroundColor: Colors.red,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final isRunning = ref.watch(timerProvider);
          return isRunning
              ? const SizedBox()
              : GNav(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Theme.of(context).focusColor,
                  activeColor: Theme.of(context).primaryColor,
                  gap: 6,
                  tabs: const [
                    GButton(icon: Icons.home, text: "Home"),
                    GButton(icon: Icons.adjust, text: "Run"),
                    GButton(icon: Icons.groups, text: "Social"),
                    GButton(
                        icon: Icons.account_circle_rounded, text: "Profile"),
                  ],
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
        },
      ),
    );
  }
}
