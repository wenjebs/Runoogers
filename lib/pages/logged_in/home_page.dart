import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runningapp/components/side_drawer.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/leaderboards_page/leaderboards_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/run_stats_page/run_stats_page.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_page.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';
import 'package:runningapp/pages/logged_in/settings_page/settings_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/add_friends_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/social_media_page.dart';
import 'package:runningapp/pages/logged_in/story_page/story_page.dart';
import 'package:runningapp/pages/logged_in/training_page/onboarding/training_onboarding_page.dart';
import 'package:runningapp/pages/logged_in/training_page/training_page.dart';
import 'package:runningapp/pages/logged_in/user_page.dart';
import 'package:runningapp/providers.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late int _selectedIndex = 0;
  bool trainingOnboarded = false;

  final List<Widget> _pages = [
    const UserPage(),
    const RunPage(),
    const SocialMediaPage(),
    const ProfilePage(),
    StoryPage(),
    const TrainingPage(),
    const RunStatsPage(),
    const LeaderboardsPage(),
    const SettingsPage(),
    const RoutesPage(),
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
      case 9:
        return "Routes";
      default:
        return "Home";
    }
  }

  List<Widget> _getAppBarActions(int selectedIndex, BuildContext context) {
    switch (selectedIndex) {
      case 2:
        return [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFriendsPage()),
              );
            },
            icon: const Icon(Icons.person_add),
          ),
        ];
      case 3:
        return [
          IconButton(
            onPressed: Authenticator().logOut,
            icon: const Icon(Icons.logout),
          ),
        ];
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    Repository.getTrainingOnboarded().then((value) {
      setState(() {
        trainingOnboarded = value;
      });
    });
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final isRunning = ref.watch(timerProvider);
        return Scaffold(
          drawer: isRunning
              ? const SizedBox()
              : SideDrawer(
                  onTap: (index) {
                    debugPrint("Index: $index");
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
          appBar: isRunning
              ? null
              : AppBar(
                  centerTitle: true,
                  actions: _selectedIndex == 3
                      ? [
                          IconButton(
                              onPressed: Authenticator().logOut,
                              icon: const Icon(Icons.logout)),
                        ]
                      : _selectedIndex == 2 // Check if selectedIndex is 2
                          ? [
                              IconButton(
                                  onPressed: () {
                                    // Navigate to AddFriendPage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddFriendsPage()),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.person_add)), // Add Friend Icon
                            ]
                          : [],
                  title: Text(
                    getTitle(_selectedIndex),
                  ),
                  backgroundColor: Colors.red,
                ),
          backgroundColor: Colors.red,
          body: _selectedIndex == 5 && !trainingOnboarded
              ? const TrainingOnboardingPage()
              : _pages[_selectedIndex],
          bottomNavigationBar: isRunning
              ? const SizedBox()
              : GNav(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Theme.of(context).focusColor,
                  activeColor: Theme.of(context).primaryColor,
                  gap: 6,
                  selectedIndex: _selectedIndex <= 3 ? _selectedIndex : -1,
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
                ),
        );
      },
    );
  }
}
