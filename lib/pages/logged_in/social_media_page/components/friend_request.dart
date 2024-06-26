import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';

class FriendRequest extends StatefulWidget {
  final String name;
  final String userId;
  final bool added;

  const FriendRequest({
    Key? key,
    required this.name,
    required this.userId,
    required this.added,
  }) : super(key: key);

  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible)
      return SizedBox.shrink(); // If not visible, return an empty widget

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage('https://picsum.photos/id/237/200/300'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(widget.name),
            ),
            IconButton(
              onPressed: () {
                Repository.acceptFriendRequest(widget.userId);
                setState(() {
                  _isVisible = false; // Hide the widget
                });
              },
              icon: const Icon(Icons.check),
            ),
            IconButton(
              onPressed: () {
                Repository.rejectFriendRequest(widget.userId);
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
