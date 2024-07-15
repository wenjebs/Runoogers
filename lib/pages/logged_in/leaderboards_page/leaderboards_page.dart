import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_pages/leaderboard_post_creation_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/user_profile_page.dart';

class LeaderboardsPage extends StatelessWidget {
  const LeaderboardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: SearchBar(
          //     leading: Icon(Icons.search),
          //   ),
          // ),           // TODO search functionality
          DefaultTabController(
            length: 2, // Number of tabs
            child: Expanded(
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Global'),
                      Tab(text: 'Friends'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Global Leaderboard
                        Padding(
                          padding: const EdgeInsetsDirectional.all(30),
                          child: FutureBuilder(
                            future: Repository.fetchTopUsersGlobal(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final globalLeaderboard = snapshot.data!;
                              int? currentUserPlace;
                              for (int i = 0;
                                  i < globalLeaderboard.length;
                                  i++) {
                                if (FirebaseAuth.instance.currentUser!.uid ==
                                    globalLeaderboard[i]['uid']) {
                                  currentUserPlace = i + 1;
                                  break;
                                }
                              }
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: globalLeaderboard.length,
                                      itemBuilder: (context, index) {
                                        return LeaderboardCard(
                                          shareable: false,
                                          isCurrentUser: FirebaseAuth
                                                  .instance.currentUser!.uid ==
                                              globalLeaderboard[index]['uid'],
                                          userId: globalLeaderboard[index]
                                              ['uid'],
                                          index: index + 1,
                                          name: globalLeaderboard[index]
                                              ['name'],
                                          username: globalLeaderboard[index]
                                              ['username'],
                                          points: globalLeaderboard[index]
                                              ['points'],
                                        );
                                      },
                                    ),
                                  ),
                                  LeaderboardCard(
                                    shareable: true,
                                    isCurrentUser: true,
                                    userId:
                                        globalLeaderboard[currentUserPlace! - 1]
                                            ['uid'],
                                    index: currentUserPlace!,
                                    name:
                                        globalLeaderboard[currentUserPlace! - 1]
                                            ['name'],
                                    username:
                                        globalLeaderboard[currentUserPlace! - 1]
                                            ['username'],
                                    points:
                                        globalLeaderboard[currentUserPlace! - 1]
                                            ['points'],
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        // Friends Leaderboard
                        Padding(
                          padding: const EdgeInsetsDirectional.all(30),
                          child: FutureBuilder(
                            future: Repository.fetchTopUsersFriends(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final friendsLeaderboard = snapshot.data!;
                              return ListView.builder(
                                itemCount: friendsLeaderboard.length,
                                itemBuilder: (context, index) {
                                  return LeaderboardCard(
                                      shareable: false,
                                      isCurrentUser: FirebaseAuth
                                              .instance.currentUser!.uid ==
                                          friendsLeaderboard[index]['uid'],
                                      userId: friendsLeaderboard[index]['uid'],
                                      index: index + 1,
                                      name: friendsLeaderboard[index]['name'],
                                      username: friendsLeaderboard[index]
                                          ['username'],
                                      points: friendsLeaderboard[index]
                                          ['points']);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardCard extends StatelessWidget {
  final int index;
  final String username;
  final int points;
  final String name;
  final String userId;
  final bool isCurrentUser;
  final bool shareable;

  const LeaderboardCard({
    super.key,
    required this.username,
    required this.name,
    required this.points,
    required this.index,
    required this.userId,
    required this.isCurrentUser,
    required this.shareable,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[100] : Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: isCurrentUser ? 4 : 0,
              color: isCurrentUser ? Colors.blue : Colors.grey,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("$index."),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(44),
                      child: Image.network(
                        'https://picsum.photos/seed/183/600',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name (@$username)',
                      style: const TextStyle(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$points pts',
                      style: const TextStyle(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  shareable ? Icons.share : Icons.chevron_right_rounded,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () {
                  if (shareable) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaderboardPostCreationPage(
                              username: username,
                              leaderboardPoints: points,
                              leaderboardRank: index)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfilePage(userId: userId)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Widget leading;
  const SearchBar({super.key, required this.leading});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: leading,
        hintText: 'Search...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
