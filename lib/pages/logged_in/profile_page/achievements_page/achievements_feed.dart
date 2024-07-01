import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievement.dart';

class AchievementsFeed extends StatefulWidget {
  const AchievementsFeed({super.key});

  @override
  AchievementsFeedState createState() => AchievementsFeedState();
}

class AchievementsFeedState extends State<AchievementsFeed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Repository.fetchUserAchievements().asStream(),
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
                        child: Achievement(
                          picture: achievement[
                              'picture'], // Adjust according to your data structure
                          name: achievement[
                              'name'], // Adjust according to your data structure
                          description: achievement[
                              'description'], // Adjust according to your data structure
                          points: achievement[
                              'points'], // Adjust according to your data structure
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
    );
  }
}
