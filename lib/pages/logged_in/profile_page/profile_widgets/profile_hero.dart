import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class ProfileHero extends StatelessWidget {
  final String avatarUrl;
  const ProfileHero({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          // BACKGROUND IMAGE CONTAINER
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: O3D(
                    src: avatarUrl,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
