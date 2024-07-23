import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  final String name;
  final String username;
  const ProfileDetails({super.key, required this.name, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  "@$username",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
