import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/user_profile_page.dart';

class RunningPostComment extends StatefulWidget {
  final String postId;
  final String commentId;
  final String userId;
  final String name;
  final String comment;
  final Repository repository;
  const RunningPostComment({
    super.key,
    required this.postId,
    required this.commentId,
    required this.userId,
    required this.comment,
    required this.name,
    required this.repository,
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
          FutureBuilder<String>(
            future: widget.repository.fetchProfilePic(widget.userId),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle errors, e.g., display a default profile picture
                return const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                  radius: 20,
                );
              } else {
                // When data is fetched successfully, display the profile picture
                return CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!),
                  radius: 20,
                );
              }
            },
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
                          builder: (context) => UserProfilePage(
                              auth: FirebaseAuth.instance,
                              repository: widget.repository,
                              userId: widget.userId)),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
