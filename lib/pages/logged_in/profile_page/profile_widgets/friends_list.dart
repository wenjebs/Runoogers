import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/profile_peek.dart';

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
              return const Center(child: Text('No friends]'));
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
