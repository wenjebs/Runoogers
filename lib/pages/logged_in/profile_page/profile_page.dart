import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/social_media_post.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievements_feed.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/avatar_creator.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/profile_pic_editor.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/friends_list.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/profile_details.dart';
import 'package:runningapp/pages/logged_in/profile_page/profile_widgets/components/runs_logged.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/runs_provider.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';
import 'profile_widgets/profile_hero.dart';

class ProfilePage extends ConsumerWidget {
  final FirebaseAuth auth;
  const ProfilePage({super.key, required this.auth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Repository repository = Repository();
    final userInfo = ref.watch(userInformationProvider).asData?.value;
    final runsSnapshot = ref.watch(getRunsProvider(auth.currentUser!.uid));

    final name = userInfo?['name'] as String?;
    final username = userInfo?['username'] as String?;
    int runsCount = 0;

    if (runsSnapshot is AsyncData<QuerySnapshot<Object?>>) {
      runsCount = runsSnapshot.value.docs.length;
    } else {}
    final friendsCount = (userInfo?['friends'] as List?)?.length ?? 69;
    final achievementsCount =
        (userInfo?['achievements'] as List?)?.length ?? 69;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                            repository.getUserProfile(auth.currentUser!.uid),
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarCreatorWidget(
                              auth: FirebaseAuth.instance,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Avatar'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        elevation: 4.0,
                        shadowColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePicEditor(
                                  auth: FirebaseAuth.instance,
                                  storage: FirebaseStorage.instance,
                                  firestore: FirebaseFirestore.instance)),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Picture'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          elevation: 4.0,
                          shadowColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )),
                ])),
            // Profile details
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: name != null && username != null
                  ? ProfileDetails(name: name, username: username)
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
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
                            builder: (context) => const RunsSection(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$runsCount',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
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
                              repository: Repository(),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$achievementsCount',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
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
                              builder: (context) => FriendsList(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid)),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$friendsCount',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
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
                      repository,
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
}
