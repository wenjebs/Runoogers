import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/friend_request.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key, required this.repository});

  final Repository repository;

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  List<String> friendsList = [];

  @override
  void initState() {
    super.initState();
    friendsList = [];
    widget.repository.getFriendList().then((value) {
      friendsList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<String>>(
        future: widget.repository.getFriendRequests(),
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

                return FutureBuilder<UserModel>(
                  future: widget.repository.getUserProfile(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text('Loading...'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        leading: const Icon(Icons.error),
                        title: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      bool isFriend = friendsList.contains(
                          userId); // Check if userId is in the friends list
                      return FriendRequest(
                        repository: widget.repository,
                        name: snapshot.data!.name,
                        userId: userId,
                        profilePic: snapshot.data!.profilePic,
                        added: isFriend,
                      );
                    } else {
                      return const ListTile(
                        leading: Icon(Icons.error_outline),
                        title: Text('Unknown error'),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("No friend requests."));
          }
        },
      ),
    );
  }
}
