import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/profile_page/activities_page/runs_logged_page.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              // padding: const EdgeInsets.all(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(),
                    child: const Text(
                      "Achievements",
                    ),
                  ),
                  Divider(
                    color: Colors.black.withOpacity(0.2),
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RunsLoggedPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(),
                      child: const Text("Runs"),
                    ),
                  ),
                  Divider(
                    color: Colors.black.withOpacity(0.2),
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(),
                    child: const Text("Settings"),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
