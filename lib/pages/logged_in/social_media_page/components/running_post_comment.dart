import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final likesCountProvider =
    StreamProvider.family<int, Map<String, String>>((ref, ids) {
  // Extract postId and commentId from the passed parameters
  final postId = ids['postId']!;
  final commentId = ids['commentId']!;

  // Return a stream that listens to the likes subcollection of the comment document
  return FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .doc(commentId)
      .collection('likes')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.length); // Map the snapshot to get the count of likes
});

class RunningPostComment extends StatefulWidget {
  final String postId;
  final String commentId;
  final String userId;
  final String name;
  final String comment;

  const RunningPostComment({
    super.key,
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.comment,
    required this.name,
  });

  @override
  State<RunningPostComment> createState() => _RunningPostCommentState();
}

class _RunningPostCommentState extends State<RunningPostComment> {
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserProfilePage(userId: widget.userId)),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .primary, // Change text color to make it stand out
                            decoration:
                                TextDecoration.underline, // Underline the text
                          )),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                        color: Theme.of(context).colorScheme.primary,
                      ), // Add an icon
                    ],
                  ),
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
              LikesCountDisplay(
                postId: widget.postId,
                commentId: widget.commentId,
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  setState(() {
                    Repository.addLikeToComment(
                        widget.postId, widget.commentId, widget.userId);
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

class LikesCountDisplay extends StatelessWidget {
  final String postId;
  final String commentId;

  const LikesCountDisplay({
    super.key,
    required this.postId,
    required this.commentId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        debugPrint("$postId, $commentId");
        final likesCount = ref.watch(likesCountProvider({
          'postId': postId,
          'commentId': commentId,
        }));
        return likesCount.when(
          data: (countX) => Text('$countX'),
          loading: () => const CircularProgressIndicator(),
          error: (e, stack) => Text('Error: $e'),
        );
      },
    );
  }
}
