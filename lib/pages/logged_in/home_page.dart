import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runningapp/pages/logged_in/profile_page.dart';
import 'package:runningapp/pages/logged_in/run_page.dart';
import 'package:runningapp/pages/logged_in/social_page.dart';
import 'package:runningapp/pages/logged_in/user_page.dart';

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
  ];

  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        backgroundColor: const Color(0xff4D869C),
        gap: 6,
        tabs: const [
          GButton(icon: Icons.home, text: "Home"),
          GButton(icon: Icons.adjust, text: "Run"),
          GButton(icon: Icons.groups, text: "Social"),
          GButton(icon: Icons.account_circle_rounded, text: "Profile"),
        ],
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
