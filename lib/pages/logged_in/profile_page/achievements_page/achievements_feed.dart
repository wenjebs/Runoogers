import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/shareable_achievement.dart';

class AchievementsFeed extends StatefulWidget {
  final String? userId;
  final Repository repository;
  const AchievementsFeed({super.key, this.userId, required this.repository});

  @override
  AchievementsFeedState createState() => AchievementsFeedState();
}

class AchievementsFeedState extends State<AchievementsFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: widget.repository
            .fetchUserAchievements(uid: widget.userId)
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final achievements = snapshot.data!;
            if (achievements.isEmpty) {
              return const Center(child: Text('No achievements'));
            }
            return Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = achievements[index];
                        return Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ShareableAchievement(
                            picture: achievement['picture'],
                            name: achievement['name'],
                            description: achievement['description'],
                            points: achievement['points'],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No achievements found'));
          }
        },
      ),
    );
  }
}
