import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/home_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/run_stats_page/run_stats_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_pages/normal_post_creation_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/social_media_page.dart';
import 'package:runningapp/pages/logged_in/story_page/story_page.dart';
import 'package:runningapp/pages/logged_in/training_page/onboarding/training_onboarding_page.dart';
import 'package:runningapp/pages/logged_in/training_page/training_page.dart';
// Import your user data model and data fetching service
// import 'path_to_your_user_data_model.dart';
// import 'path_to_your_data_fetching_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  bool trainingOnboarded = false;
  @override
  void initState() {
    super.initState();
    Repository.getTrainingOnboarded().then((value) {
      setState(() {
        trainingOnboarded = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Repository.getUserProfile(
          auth.FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          User user = snapshot.data!;
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Text(
                      "Welcome, ${user.name}!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQT9LQk2qPdPE0IK_35wLlAkh8-5Xsg-6NaIQ&s'), // Background image
                                  fit: BoxFit
                                      .cover, // Cover the entire container space
                                ),
                              ),
                              height: MediaQuery.of(context).size.height *
                                  0.2, // 20% of screen height
                              width: double
                                  .infinity, // Take up full width available
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.fitness_center,
                                        size: 50), // Example icon
                                    Text(
                                      'No training plan found.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate based on trainingOnboarded boolean
                                  if (trainingOnboarded) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TrainingPage()),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TrainingOnboardingPage()),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(
                                            0.5), // Semi-transparent blue overlay
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          10), // Rounded corner for aesthetic
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Start a training plan",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(20),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        crossAxisCount: 3,
                        children: const <Widget>[
                          ServiceIcon(title: 'Story', icon: Icons.book),
                          ServiceIcon(
                              title: 'Track Run', icon: Icons.directions_run),
                          ServiceIcon(title: 'All', icon: Icons.all_inclusive),
                        ],
                      ),
                    ),
                    Expanded(
                        child: const SocialMediaPage(
                            showFloatingActionButton: false)),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PostCreationPage()),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No data found')),
          );
        }
      },
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const ServiceIcon({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Story') {
          // Navigate to StoryPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 4)),
          );
        } else if (title == 'Track Run') {
          // Navigate to TrackPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 1)),
          );
        } else if (title == 'All') {
          // Navigate to AllPage
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 400,
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: 3,
                  children: const <Widget>[
                    ServiceIcon(title: 'Run Stats', icon: Icons.show_chart),
                    ServiceIcon(title: 'Leaderboards', icon: Icons.leaderboard),
                    ServiceIcon(title: 'Routes', icon: Icons.map),
                    ServiceIcon(title: 'Training', icon: Icons.fitness_center),
                    ServiceIcon(title: 'Track Run', icon: Icons.directions_run),
                    ServiceIcon(title: 'Story', icon: Icons.book),
                    ServiceIcon(title: 'Settings', icon: Icons.settings),
                    ServiceIcon(title: 'Social Feed', icon: Icons.share),
                  ],
                ),
              );
            },
          );
        } else if (title == 'Run Stats') {
          // Navigate to RunStatsPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 6)),
          );
        } else if (title == 'Leaderboards') {
          // Navigate to LeaderboardsPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 7)),
          );
        } else if (title == 'Routes') {
          // Navigate to RoutesPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 9)),
          );
        } else if (title == 'Training') {
          // Navigate to TrainingPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 5)),
          );
        } else if (title == 'Settings') {
          // Navigate to SettingsPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 8)),
          );
        } else if (title == 'Social Feed') {
          // Navigate to SocialMediaPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage(initialIndex: 3)),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
            radius: 30,
            child: Icon(icon,
                size: 40,
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
