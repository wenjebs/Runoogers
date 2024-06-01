import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        "SETTINGS HERE",
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}
