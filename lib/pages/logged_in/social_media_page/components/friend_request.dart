import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';

class FriendRequest extends StatefulWidget {
  final Repository repository;
  final String name;
  final String userId;
  final bool added;
  final String profilePic;

  const FriendRequest({
    super.key,
    required this.name,
    required this.userId,
    required this.added,
    required this.repository,
    required this.profilePic,
  });

  @override
  FriendRequestState createState() => FriendRequestState();
}

class FriendRequestState extends State<FriendRequest> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.profilePic),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(widget.name),
            ),
            IconButton(
              onPressed: () {
                widget.repository.acceptFriendRequest(widget.userId);
                setState(() {
                  _isVisible = false; // Hide the widget
                });
              },
              icon: const Icon(Icons.check),
            ),
            IconButton(
              onPressed: () {
                widget.repository.rejectFriendRequest(widget.userId);
                setState(() {
                  _isVisible = false; // Hide the widget
                });
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
