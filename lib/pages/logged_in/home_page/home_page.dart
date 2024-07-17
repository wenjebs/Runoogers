import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/leaderboards_page/leaderboards_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/run_stats_page/run_stats_page.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_view.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';
import 'package:runningapp/pages/logged_in/settings_page/settings_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/friend_adding_pages/add_friends_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/social_media_page.dart';
import 'package:runningapp/pages/logged_in/story_page/story_page.dart';
import 'package:runningapp/pages/logged_in/training_page/onboarding/training_onboarding_page.dart';
import 'package:runningapp/pages/logged_in/training_page/training_page.dart';
import 'package:runningapp/pages/logged_in/home_page/user_page.dart';
import 'package:runningapp/providers.dart';

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
    const RunPage(
      title: "",
      storyRun: false,
    ),
    const ProfilePage(),
    const SocialMediaPage(),
    const StoryPage(),
    const TrainingPage(),
    const RunStatsPage(),
    const LeaderboardsPage(),
    const SettingsPage(),
    const RoutesView(),
  ];

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Run";
      case 2:
        return "Profile";
      case 3:
        return "My Feed";
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
          appBar: isRunning
              ? null
              : AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  actions: _selectedIndex == 2
                      ? [
                          IconButton(
                              onPressed: () async {
                                await Repository.logoutAndRedirect(context);
                              },
                              icon: const Icon(Icons.logout)),
                        ]
                      : _selectedIndex == 3
                          ? [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddFriendsPage()),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.person_add)), // Add Friend Icon
                            ]
                          : [],
                  title: Text(
                    getTitle(_selectedIndex),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          body: _selectedIndex == 5 && !trainingOnboarded
              ? const TrainingOnboardingPage()
              : _pages[_selectedIndex],
          bottomNavigationBar: isRunning
              ? const SizedBox()
              : GNav(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Theme.of(context).colorScheme.onPrimary,
                  activeColor: Theme.of(context).colorScheme.primary,
                  gap: 2,
                  selectedIndex: _selectedIndex <= 2 ? _selectedIndex : -1,
                  tabs: const [
                    GButton(icon: Icons.home, text: "Home"),
                    GButton(icon: Icons.adjust, text: "Run"),
                    // GButton(icon: Icons.groups, text: "Social"),
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