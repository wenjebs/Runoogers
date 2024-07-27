import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/social_media_post.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievements_feed.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/friends_list.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_details.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/runs_logged.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_hero.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final Repository repository;
  const UserProfilePage(
      {super.key, required this.userId, required this.repository});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isRequestSent = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: widget.repository.getUserProfile(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: Text('User not found'),
              ),
            );
          } else {
            UserModel user = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('User Profile'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    // Profile hero
                    Material(
                        elevation: 10,
                        child: Stack(children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: FutureBuilder<UserModel>(
                                future:
                                    Repository().getUserProfile(widget.userId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.hasData) {
                                    UserModel user = snapshot.data!;
                                    return ProfileHero(
                                        avatarUrl: user.avatarUrl,
                                        profilePic: user.profilePic);
                                  } else {
                                    return const Text('Unknown error occurred');
                                  }
                                }),
                          ),
                        ])),
                    // Profile details
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ProfileDetails(
                          name: user.name, username: user.username),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (user.friends
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? const Text('Friends')
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isRequestSent = true;
                                });
                                await widget.repository
                                    .sendFriendRequest(user.uid);
                              },
                              child: Text(_isRequestSent
                                  ? 'Request Sent'
                                  : 'Add Friend'),
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RunsSection()),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user.totalRuns.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const Text(
                                    'Runs',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AchievementsFeed(
                                          repository: Repository())),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user.achievements.length.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const Text(
                                    'Achievements',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FriendsList(userId: user.uid)),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user.friends.length.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const Text(
                                    'Friends',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: GetUserPostService()
                          .getPosts([FirebaseAuth.instance.currentUser!.uid]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final posts = snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Post.fromMap(data);
                        }).toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return RunningPost(
                              Repository(),
                              post: post,
                            );
                          },
                        );
                      },
                    ),
                  ]),
                ),
              ),
            );
          }
        });
  }
}
