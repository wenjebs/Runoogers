import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/profile_peek.dart';
import 'package:runningapp/pages/logged_in/social_media_page/friend_adding_pages/friend_requests_list.dart';

class FriendsList extends StatefulWidget {
  final String userId;
  const FriendsList({super.key, required this.userId});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (widget.userId == FirebaseAuth.instance.currentUser!.uid)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FriendRequestPage(repository: Repository())),
                );
              },
              child: Text(
                'Requests',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: Repository().getAllFriendsProfile(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No friends found'));
          } else {
            final friends = snapshot.data!;
            if (friends.isEmpty) {
              return const Center(child: Text('No friends'));
            }
            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ProfilePeek(user: friend);
              },
            );
          }
        },
      ),
    );
  }
}
