import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:runningapp/pages/profile_page.dart';
import 'package:runningapp/pages/run_page.dart';
import 'package:runningapp/pages/social_page.dart';
import 'package:runningapp/pages/user_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserPage(),
    RunPage(),
    SocialPage(),
    ProfilePage(),
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
        backgroundColor: Colors.grey,
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
