import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/leaderboards_page/podium.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_pages/leaderboard_post_creation_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/user_profile_page.dart';

class LeaderboardsPage extends StatelessWidget {
  final Repository repository;
  final FirebaseAuth auth;
  const LeaderboardsPage({
    super.key,
    required this.repository,
    required this.auth,
  });

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
                            future: repository.fetchTopUsersGlobal(),
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
                                if (auth.currentUser!.uid ==
                                    globalLeaderboard[i]['uid']) {
                                  currentUserPlace = i + 1;
                                  break;
                                }
                              }
                              return CustomScrollView(
                                slivers: <Widget>[
                                  if (globalLeaderboard.length >= 3)
                                    SliverToBoxAdapter(
                                      child: Column(
                                        children: [
                                          LeaderboardCard(
                                            shareable: true,
                                            isCurrentUser: true,
                                            userId: globalLeaderboard[
                                                currentUserPlace! - 1]['uid'],
                                            index: currentUserPlace,
                                            name: globalLeaderboard[
                                                currentUserPlace - 1]['name'],
                                            username: globalLeaderboard[
                                                    currentUserPlace - 1]
                                                ['username'],
                                            points: globalLeaderboard[
                                                currentUserPlace - 1]['points'],
                                            repository: repository,
                                            profilePic: globalLeaderboard[
                                                    currentUserPlace - 1]
                                                ['profilePic'],
                                            auth: auth,
                                          ),
                                          PodiumWidget(
                                            firstPlace: UserModel.fromMap(
                                                globalLeaderboard[0]),
                                            secondPlace: UserModel.fromMap(
                                                globalLeaderboard[1]),
                                            thirdPlace: UserModel.fromMap(
                                                globalLeaderboard[2]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final skipThree = index + 3;
                                        return LeaderboardCard(
                                          shareable: false,
                                          isCurrentUser:
                                              auth.currentUser!.uid ==
                                                  globalLeaderboard[skipThree]
                                                      ['uid'],
                                          userId: globalLeaderboard[skipThree]
                                              ['uid'],
                                          index: skipThree + 1,
                                          name: globalLeaderboard[skipThree]
                                              ['name'],
                                          username: globalLeaderboard[skipThree]
                                              ['username'],
                                          points: globalLeaderboard[skipThree]
                                              ['points'],
                                          repository: repository,
                                          profilePic:
                                              globalLeaderboard[skipThree]
                                                  ['profilePic'],
                                          auth: auth,
                                        );
                                      },
                                      childCount: globalLeaderboard.length - 3,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        // Friends Leaderboard
                        Padding(
                          padding: const EdgeInsetsDirectional.all(30),
                          child: FutureBuilder(
                            future: repository.fetchTopUsersFriends(),
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
                                    isCurrentUser: auth.currentUser!.uid ==
                                        friendsLeaderboard[index]['uid'],
                                    userId: friendsLeaderboard[index]['uid'],
                                    index: index + 1,
                                    name: friendsLeaderboard[index]['name'],
                                    username: friendsLeaderboard[index]
                                        ['username'],
                                    points: friendsLeaderboard[index]['points'],
                                    repository: repository,
                                    profilePic: friendsLeaderboard[index]
                                        ['profilePic'],
                                    auth: auth,
                                  );
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
  final Repository repository;
  final String profilePic;
  final FirebaseAuth auth;

  const LeaderboardCard({
    super.key,
    required this.username,
    required this.name,
    required this.points,
    required this.index,
    required this.userId,
    required this.isCurrentUser,
    required this.shareable,
    required this.repository,
    required this.profilePic,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).colorScheme.onSecondaryFixedVariant
              : Theme.of(context)
                  .colorScheme
                  .secondaryFixed, // Softer color for current user
          borderRadius: BorderRadius.circular(
            20,
          ), // Increased border radius for roundness
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.grey.withOpacity(0.5), // Softer shadow
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$index.",
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Bold for emphasis
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    backgroundImage: NetworkImage(profilePic),
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
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$points',
                          style: TextStyle(
                            letterSpacing: 0.5, //
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  shareable ? Icons.share : Icons.chevron_right_rounded,
                  color: Colors.grey[800],
                  size: 24,
                ),
                onPressed: () {
                  if (shareable) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardPostCreationPage(
                          repository: repository,
                          leaderboardPoints: points,
                          leaderboardRank: index,
                          username: username,
                          auth: auth,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfilePage(
                          repository: repository,
                          userId: userId,
                        ),
                      ),
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
