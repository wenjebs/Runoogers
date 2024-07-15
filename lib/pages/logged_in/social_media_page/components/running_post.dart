import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/social_media_post.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievement.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_comment_feed.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/post_provider.dart';
import 'package:runningapp/pages/logged_in/social_media_page/user_profile_page.dart';

class RunningPost extends ConsumerWidget {
  final Post
      post; // TODO eventually make more posts for leaderboard rankings, achievements, etc
  final bool disableCommentButton;

  const RunningPost({
    super.key,
    required this.post,
    this.disableCommentButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likes = ref.watch(likesCountProvider(post.id));
    final name = ref.watch(userNameProvider(post.userId));

    Widget content;
    if (post.isAchievementPost) {
      debugPrint('Building achievement post');
      content = _buildAchievementPost(
          post.achievementDescription!,
          post.achievementTitle!,
          post.achievementImageUrl!,
          post.achievementPoints!);
    } else if (post.isRunPost) {
      debugPrint('Building run post');
      content = _buildRunPost(post.runImageUrl!);
    } else {
      debugPrint('Building caption post');
      content = _buildCaptionPost(post);
    }

    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: name.when(
                data: (String name) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserProfilePage(userId: post.userId)),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, // Change text color to make it stand out
                                decoration: TextDecoration
                                    .underline, // Underline the text
                              )),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: Theme.of(context).colorScheme.primary,
                          ), // Add an icon
                        ],
                      ),
                    ),
                loading: () => const Text('Loading...'),
                error: (error, _) => const Text('Error!')),
            subtitle: Text(post.caption),
          ),
          content,
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  Repository.addLikeToPost(post.id, post.userId);
                },
              ),
              likes.when(
                data: (int count) => Text('$count'),
                loading: () =>
                    const SizedBox.shrink(), // Cleaner look during loading
                error: (e, stack) =>
                    const Icon(Icons.error_outline), // Simplified error display
              ),
              const VerticalDivider(
                color: Colors.grey, // Set the color of the divider
                thickness: 1, // Set the thickness of the divider
                indent: 10, // Set the top space of the divider
                endIndent: 10, // Set the bottom space of the divider
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {
                  if (!disableCommentButton) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostCommentFeed(
                            post: post,
                          ),
                        ));
                  }
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  final commentsCount =
                      ref.watch(commentsCountProvider(post.id));
                  return commentsCount.when(
                    data: (comment) => Text('$comment'),
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

  Widget _buildAchievementPost(
      String description, String title, String imageUrl, int points) {
    return Achievement(
        description: description,
        name: title,
        picture: imageUrl,
        points: points);
  }

  Widget _buildRunPost(String runImageUrl) {
    return Image.network(
      runImageUrl,
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildCaptionPost(Post post) {
    return Column(
      children: [
        ListTile(title: Text(post.caption)),
      ],
    );
  }
}
