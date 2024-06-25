import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post_comment.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/post_provider.dart';

final commentControllerProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

class PostCommentFeed extends ConsumerWidget {
  final String id;
  final String userId;
  final String caption;
  final Object run; // This still needs to be settled as per the TODO

  const PostCommentFeed({
    super.key,
    required this.id,
    required this.userId,
    required this.caption,
    required this.run,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _commentController = ref.watch(commentControllerProvider);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: const Text('Comments')),
      body: Column(
        children: [
          RunningPost(
              id: id,
              userId: userId,
              caption: caption,
              run: run,
              disableCommentButton:
                  true), // Consider using Riverpod for state management here as well
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("No comments yet");
                }
                final comments = snapshot.data!.docs.map((doc) {
                  return RunningPostComment(
                    id: doc.id,
                    userId: doc['userId'],
                    comment: doc['comment'],
                    likes: doc['likes'],
                  );
                }).toList();
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return comments[index];
                  },
                );
              },
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(id)
                  .collection('comments')
                  .snapshots(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(id)
                        .collection('comments')
                        .add({
                      'userId': 'placeholder, change in post_comment_feed.dart',
                      'comment': _commentController.text,
                      'likes': 0,
                    });
                    // Clear the text field after sending the comment
                    _commentController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
