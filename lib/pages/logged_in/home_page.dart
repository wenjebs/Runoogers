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
import 'package:runningapp/pages/login_and_registration/login_or_register_page.dart';
import 'package:runningapp/providers.dart';
import 'package:runningapp/state/backend/authenticator.dart';

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

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Run";
      case 2:
        return "Social";
      case 3:
        return "Profile";
      case 4:
        return "Story";
      case 5:
        return "Training";
      case 6:
        return "Run Stats";
      case 7:
        return "Leaderboards";
      case 8:
        return "Settings";
      default:
        return "Home";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final isRunning = ref.watch(timerProvider);
          return isRunning
              ? const SizedBox()
              : SideDrawer(
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
        },
        child: SideDrawer(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      appBar: AppBar(
        actions: _selectedIndex == 3
            ? [
                IconButton(
                    onPressed: Authenticator().logOut,
                    icon: const Icon(Icons.logout)),
              ]
            : [],
        title: Text(
          getTitle(_selectedIndex),
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
