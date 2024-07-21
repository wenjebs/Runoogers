import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  final Repository repository;

  const RunningPost(
    this.repository, {
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
      content = _buildRunPost(context, post.runImageUrl!);
    } else if (post.isLeaderboardPost) {
      debugPrint("Building leaderboard post");
      content = _buildLeaderboardPost(
          post.leaderboardPoints!, post.rank!, post.username!, post.caption);
    } else {
      debugPrint('Building caption post');
      content = _buildCaptionPost(post);
    }

    String formattedTimestamp;

    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime postDate = post.timestamp.toDate().add(const Duration(hours: 8));

    if (DateFormat('yyyy-MM-dd').format(today) ==
        DateFormat('yyyy-MM-dd').format(postDate)) {
      formattedTimestamp = 'Today at ${DateFormat('h:mma').format(postDate)}';
    } else if (DateFormat('yyyy-MM-dd').format(yesterday) ==
        DateFormat('yyyy-MM-dd').format(postDate)) {
      formattedTimestamp =
          'Yesterday at ${DateFormat('h:mma').format(postDate)}';
    } else {
      formattedTimestamp =
          '${DateFormat('d MMMM').format(postDate)} at ${DateFormat('h:mma').format(postDate)}';
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
                              builder: (context) => UserProfilePage(
                                  repository: Repository(),
                                  userId: post.userId)),
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.caption),
                Text(formattedTimestamp,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    )),
              ],
            ),
          ),
          content,
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  repository.addLikeToPost(post.id, post.userId);
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
                            Repository(),
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

  Widget _buildRunPost(BuildContext context, String runImageUrl) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: InteractiveViewer(
                // Allows pinch-to-zoom
                panEnabled: false, // Set it to false to prevent panning.
                boundaryMargin: const EdgeInsets.all(80),
                minScale: 0.5,
                maxScale: 4,
                child: Image.network(
                  runImageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        );
      },
      child: Image.network(
        runImageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCaptionPost(Post post) {
    return const SizedBox.shrink();
  }

  Widget _buildLeaderboardPost(
      int points, int rank, String username, String caption) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://img.freepik.com/free-vector/colorful-confetti-background-with-text-space_1017-32374.jpg',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$username is rank #$rank globally!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'with $points points',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
