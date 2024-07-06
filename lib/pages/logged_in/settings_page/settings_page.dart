import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/providers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkmode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  onPressed: () {
                    ref.read(themeProviderRef.notifier).toggleTheme(darkmode);
                    debugPrint(darkmode.toString());
                    setState(() {
                      darkmode = !darkmode;
                    });
                  },
                  child: const Text('Toggle Theme'),
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  // Repository.updateQuestProgress(23, 100, 0, "ivan");
                },
                child: const Text("Test"))
          ],
        ),
      ),
    );
  }
}
