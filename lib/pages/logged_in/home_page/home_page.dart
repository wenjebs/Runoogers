import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/leaderboards_page/leaderboards_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/friends_list.dart';
import 'package:runningapp/pages/logged_in/run_stats_page/run_stats_page.dart';
import 'package:runningapp/pages/logged_in/routes_page/routes_view.dart';
import 'package:runningapp/pages/logged_in/run_page/map_and_location_logic/location_service.dart';
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

  final Repository repository;
  get getRepository => repository;
  const HomePage({super.key, this.initialIndex = 0, required this.repository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  late int _selectedIndex = 0;
  bool trainingOnboarded = false;
  bool onboarded = false;

  final List<Widget> _pages = [
    UserPage(repository: Repository(), auth: FirebaseAuth.instance),
    RunPage(
      locationService: LocationService(),
      repository: Repository(),
      title: "",
      storyRun: false,
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
    ProfilePage(auth: FirebaseAuth.instance),
    SocialMediaPage(repository: Repository(), auth: FirebaseAuth.instance),
    StoryPage(
      Repository(),
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
    TrainingPage(
      repository: Repository(),
      auth: FirebaseAuth.instance,
    ),
    const RunStatsPage(),
    LeaderboardsPage(
      repository: Repository(),
      auth: FirebaseAuth.instance,
    ),
    SettingsPage(
      repository: Repository(),
      auth: FirebaseAuth.instance,
    ),
    RoutesView(
      repository: Repository(),
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
    FriendsList(userId: FirebaseAuth.instance.currentUser!.uid),
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
        return "Stories";
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
      case 10:
        return "Friends";
      default:
        return "Home";
    }
  }

  @override
  void initState() {
    super.initState();
    widget.repository.getTrainingOnboarded().then((value) {
      setState(() {
        trainingOnboarded = value;
      });
    });

    widget.repository.getOnboarded().then((value) {
      setState(() {
        onboarded = value;
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
                  centerTitle: false,
                  actions: _selectedIndex == 2
                      ? [
                          IconButton(
                              onPressed: () async {
                                await widget.repository
                                    .logoutAndRedirect(context);
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
                                      builder: (context) => AddFriendsPage(
                                        repository: Repository(),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.search_rounded),
                              ), // Add Friend Icon
                            ]
                          : [],
                  title: Text(
                    getTitle(_selectedIndex),
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          body: _selectedIndex == 5 && !trainingOnboarded
              ? TrainingOnboardingPage(auth: FirebaseAuth.instance)
              : _pages[_selectedIndex],
          bottomNavigationBar: isRunning
              ? const SizedBox()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      elevation: 30.0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: GNav(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryFixed,
                          color: Theme.of(context).colorScheme.onPrimary,
                          activeColor: Theme.of(context).colorScheme.primary,
                          gap: 2,
                          selectedIndex:
                              _selectedIndex <= 2 ? _selectedIndex : -1,
                          tabs: const [
                            GButton(
                              icon: Icons.home,
                              text: "Home",
                              key: Key("homeButton"),
                            ),
                            GButton(
                              icon: Icons.adjust,
                              text: "Run",
                              key: Key("runButton"),
                            ),
                            // GButton(icon: Icons.groups, text: "Social"),
                            GButton(
                              icon: Icons.account_circle_rounded,
                              text: "Profile",
                              key: Key("profileButton"),
                            ),
                          ],
                          onTabChange: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
