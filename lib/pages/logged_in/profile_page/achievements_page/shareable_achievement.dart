import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_pages/achievement_post_creation_page.dart';

class ShareableAchievement extends StatelessWidget {
  final String picture;
  final String name;
  final String description;
  final int points;

  const ShareableAchievement({
    super.key,
    required this.picture,
    required this.name,
    required this.description,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Align items in the Row
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(picture),
                      radius: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text('$points pts',
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(description, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Share button added here, outside the inner Row but inside the outer Row
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AchievementPostCreationPage(
                    auth: FirebaseAuth.instance,
                    repository: Repository(),
                    picture: picture,
                    name: name,
                    description: description,
                    points: points,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
