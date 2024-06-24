import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post_comment.dart';

class PostCommentFeed extends StatefulWidget {
  final String id;
  final String userId;
  final String caption;
  final Object run; // TODO figure out how to settle run object / map object
  final int likes;

  const PostCommentFeed(
      {super.key,
      required this.id,
      required this.userId,
      required this.caption,
      required this.run,
      required this.likes});

  @override
  State<PostCommentFeed> createState() => _PostCommentFeedState();
}

class _PostCommentFeedState extends State<PostCommentFeed> {
  String get id => widget.id;
  String get userId => widget.userId;
  String get caption => widget.caption;
  Object get run => widget.run;
  int get likes => widget.likes;

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              likes: likes,
              disableCommentButton: true),
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
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(id)
                        .collection('comments')
                        .add({
                      'userId': 'TODO: Get user ID',
                      'comment': _commentController.text,
                      'likes': 0,
                    });
                    Navigator.pop(context);
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
