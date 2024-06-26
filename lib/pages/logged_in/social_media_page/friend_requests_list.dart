import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/friend_request.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  List<String> friendsList = [];

  @override
  void initState() {
    super.initState();
    friendsList = [];
    Repository.getFriendList().then((value) {
      friendsList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where there is no user logged in
      return Scaffold(
        body: Center(child: Text("Please log in to see friend requests.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: FutureBuilder<List<String>>(
        future: Repository.getFriendRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final friendRequestUserIds = snapshot.data!;
            return ListView.builder(
              itemCount: friendRequestUserIds.length,
              itemBuilder: (context, index) {
                String userId = friendRequestUserIds[index];

                return FutureBuilder<String>(
                  future: Repository.fetchName(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text('Loading...'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: Icon(Icons.error),
                        title: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      bool isFriend = friendsList.contains(
                          userId); // Check if userId is in the friends list
                      return FriendRequest(
                        name: snapshot.data!,
                        userId: userId,
                        added:
                            isFriend, // Set added based on whether userId is in friends list
                      );
                    } else {
                      return ListTile(
                        leading: Icon(Icons.error_outline),
                        title: Text('Unknown error'),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Center(child: Text("No friend requests."));
          }
        },
      ),
    );
  }
}
