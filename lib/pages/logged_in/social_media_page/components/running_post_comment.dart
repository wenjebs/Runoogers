import 'package:flutter/material.dart';

class RunningPostComment extends StatefulWidget {
  final String id;
  final String userId;
  final String comment;
  final int likes;

  const RunningPostComment({
    super.key,
    required this.id,
    required this.userId,
    required this.comment,
    required this.likes,
  });

  @override
  State<RunningPostComment> createState() => _RunningPostCommentState();
}

class _RunningPostCommentState extends State<RunningPostComment> {
  int likes = 0;

  @override
  void initState() {
    super.initState();
    likes = widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            // Placeholder for commenter's profile picture
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userId,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.comment),
                // Text(
                //   widget.timestamp,
                //   style: TextStyle(color: Colors.grey, fontSize: 12),
                // ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.likes.toString(),
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  setState(() {
                    likes++;
                    // TODO connect likes to backend
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
