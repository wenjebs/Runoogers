import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';

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
                              return ListView.builder(
                                itemCount: globalLeaderboard.length,
                                itemBuilder: (context, index) {
                                  return LeaderboardCard(
                                      index: index + 1,
                                      name: globalLeaderboard[index]['name'],
                                      username: globalLeaderboard[index]
                                          ['username'],
                                      points: globalLeaderboard[index]
                                          ['points']);
                                },
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

  const LeaderboardCard({
    super.key,
    required this.username,
    required this.name,
    required this.points,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: Colors.grey,
              offset: Offset(
                0,
                1,
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                        child: Center(
                          child: Text(
                            '$name (@$username)',
                            style: const TextStyle(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '$points pts',
                          style: const TextStyle(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black,
                size: 24,
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
