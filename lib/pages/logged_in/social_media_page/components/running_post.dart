import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_comment_feed.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/post_provider.dart';

class RunningPost extends ConsumerWidget {
  final String id;
  final String userId;
  final String caption;
  final Object run; // TODO figure out how to settle run object / map object
  final bool disableCommentButton;

  const RunningPost({
    super.key,
    required this.id,
    required this.userId,
    required this.caption,
    required this.run,
    this.disableCommentButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likes = ref.watch(likesCountProvider(id));
    final name =
        ref.watch(userNameProvider(userId)); // Assuming userNameProvider exists

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: name.when(
                data: (String name) => Text('$name',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                loading: () => const Text('Loading...'),
                error: (error, _) => const Text('Error!')),
            subtitle: Text(caption),
          ),
          Image.network(
              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixlr.com%2Fimage-generator%2F&psig=AOvVaw3La1hOtbr1bK0DXQmiuNbF&ust=1718610129395000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOjm3uTP34YDFQAAAAAdAAAAABAE'),
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  Repository.addLikeToPost(id, userId);
                },
              ),
              likes.when(
                data: (int count) =>
                    Text('$count likes'), // Display the actual number
                loading: () =>
                    const CircularProgressIndicator(), // Show a loading indicator
                error: (e, stack) =>
                    Text('Error: $e'), // Display an error message
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  if (!disableCommentButton) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostCommentFeed(
                            id: id,
                            userId: userId,
                            caption: caption,
                            run: run,
                          ),
                        ));
                  }
                },
              ),
              // Assuming commentsProvider exists to fetch comments count
              Consumer(
                builder: (context, ref, _) {
                  final commentsCount = ref.watch(commentsCountProvider(id));
                  return commentsCount.when(
                    data: (count) => Text('$count comments'),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, _) => const Text('Error!'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
