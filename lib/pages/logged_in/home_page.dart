import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_page.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';
import 'package:runningapp/pages/logged_in/social_page.dart';
import 'package:runningapp/pages/logged_in/user_page.dart';
import 'package:runningapp/pages/test/test_page.dart';
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
    const SectionTextStreamInput(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    GButton(icon: Icons.abc),
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
