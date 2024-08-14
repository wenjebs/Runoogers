import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/social_media_post.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/friends_list.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';
import 'package:runningapp/pages/logged_in/training_page/training_card.dart';

class UserPage extends ConsumerWidget {
  final Repository repository;
  final FirebaseAuth auth;
  const UserPage({super.key, required this.repository, required this.auth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('current user is ${auth.currentUser!.uid}');
    final friendUids = ref.watch(friendsProvider);
    final trainingOnboarded = ref.watch(trainingOnboardedProvider);
    return FutureBuilder<UserModel>(
      future: repository.getUserProfile(auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          UserModel user = snapshot.data!;
          return Scaffold(
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 10.0,
                  ),
                  child: Text(
                    "Welcome, ${user.name}!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                trainingOnboarded.when(data: (trainingOnboarded) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TrainingCard(
                      repository: repository,
                      trainingOnboarded: trainingOnboarded,
                    ),
                  );
                }, loading: () {
                  return const CircularProgressIndicator();
                }, error: (error, stackTrace) {
                  return Text('Error: $error');
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> serviceIcons = [
                        {'title': 'Story', 'icon': Icons.book},
                        {'title': 'Track Run', 'icon': Icons.directions_run},
                        {'title': 'All', 'icon': Icons.all_inclusive_outlined},
                      ];

                      return ServiceIcon(
                        title: serviceIcons[index]['title'],
                        icon: serviceIcons[index]['icon'],
                      );
                    },
                  ),
                ),
                friendUids.when(
                  data: (friendUids) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: GetUserPostService().getPosts(friendUids),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 64.0),
                              child: Text('No posts found, go for a run!'),
                            ),
                          );
                        }
                        final posts = snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          debugPrint(data.toString());
                          return Post.fromMap(data);
                        }).toList();
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return RunningPost(repository, post: post);
                          },
                        );
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(body: Center(child: Text('No data found')));
        }
      },
    );
  }
}

class ServiceIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const ServiceIcon({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Story') {
          // Navigate to StoryPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      initialIndex: 4,
                      repository: Repository(),
                    )),
          );
        } else if (title == 'Track Run') {
          // Navigate to TrackPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      initialIndex: 1,
                      repository: Repository(),
                    )),
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
                    ServiceIcon(title: 'Friends', icon: Icons.people),
                    ServiceIcon(title: 'Social Feed', icon: Icons.share),
                    ServiceIcon(title: 'Settings', icon: Icons.settings),
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
                builder: (context) => HomePage(
                      initialIndex: 6,
                      repository: Repository(),
                    )),
          );
        } else if (title == 'Leaderboards') {
          // Navigate to LeaderboardsPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      initialIndex: 7,
                      repository: Repository(),
                    )),
          );
        } else if (title == 'Routes') {
          // Navigate to RoutesPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      initialIndex: 9,
                      repository: Repository(),
                    )),
          );
        } else if (title == 'Training') {
          // Navigate to TrainingPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      initialIndex: 5,
                      repository: Repository(),
                    )),
          );
        } else if (title == 'Settings') {
          // Navigate to SettingsPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      initialIndex: 8,
                      repository: Repository(),
                    )),
          );
        } else if (title == 'Social Feed') {
          // Navigate to SocialMediaPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      initialIndex: 3,
                      repository: Repository(),
                    )),
          );
        } else if (title == 'Friends') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FriendsList(
                    userId: FirebaseAuth.instance.currentUser!.uid)),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
            radius: 30,
            child: Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
    );
  }
}
