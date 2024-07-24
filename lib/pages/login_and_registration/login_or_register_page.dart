import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/state/backend/authenticator.dart';

import 'login_page.dart';
import 'register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login , register
  void togglePages() {
    setState(() {
      debugPrint('login/rgeister: Toggling pages');
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        repository: Repository(),
        authenticator: Authenticator(),
      );
    } else {
      return RegisterPage(
        repository: Repository(),
      );
    }
  }
}
