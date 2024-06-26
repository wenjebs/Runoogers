import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';

class FriendRequestPage extends StatelessWidget {
  const FriendRequestPage({super.key});

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
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(snapshot.data!),
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
