import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/social_media_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post_comment.dart';

final commentControllerProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

class PostCommentFeed extends ConsumerWidget {
  final Post post;
  final Repository repository;
  final FirebaseAuth auth;
  const PostCommentFeed(
    this.repository, {
    super.key,
    required this.post,
    required this.auth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = ref.watch(commentControllerProvider);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: const Text('Comments')),
      body: Column(
        children: [
          RunningPost(repository, post: post, disableCommentButton: true),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("No comments yet");
                }
                final comments = snapshot.data!.docs.map((doc) {
                  return RunningPostComment(
                    repository: repository,
                    name: doc['name'],
                    postId: post.id,
                    commentId: doc.id,
                    userId: doc['userId'],
                    comment: doc['comment'],
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
                  .doc(post.id)
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
                    controller: commentController,
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
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    String name =
                        await repository.fetchName(auth.currentUser!.uid);
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(post.id)
                        .collection('comments')
                        .add({
                      'userId': auth.currentUser!.uid,
                      'name': name,
                      'comment': commentController.text,
                      'likes': 0,
                    });

                    commentController.clear();
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
