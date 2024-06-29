import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_comment_feed.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/post_provider.dart';

class RunningPost extends ConsumerWidget {
  final String id;
  final String userId;
  final String caption;
  final String
      photoUrl; // TODO eventually make more posts for leaderboard rankings, achievements, etc
  final bool disableCommentButton;

  const RunningPost({
    super.key,
    required this.id,
    required this.userId,
    required this.caption,
    required this.photoUrl,
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
                data: (String name) => Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                loading: () => const Text('Loading...'),
                error: (error, _) => const Text('Error!')),
            subtitle: Text(caption),
          ),
          Image.network(
            // TODO eventually render different types of posts
            photoUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  Repository.addLikeToPost(id, userId);
                },
              ),
              likes.when(
                data: (int count) => Text('$count likes'),
                loading: () => const CircularProgressIndicator(),
                error: (e, stack) => Text('Error: $e'),
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
                            photoUrl: photoUrl,
                          ),
                        ));
                  }
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  final commentsCount = ref.watch(commentsCountProvider(id));
                  return commentsCount.when(
                    data: (comment) => Text('$comment comments'),
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
