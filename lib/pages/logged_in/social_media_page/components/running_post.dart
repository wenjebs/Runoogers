import 'package:firebase_auth/firebase_auth.dart';
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
      content = _buildRunPost(context, post.runImageUrl!, post.runDistance!,
          post.runDuration.toString(), post.runPace!);
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
            title: Row(
              children: <Widget>[
                FutureBuilder<String>(
                  future: repository.fetchProfilePic(post.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary, // Outline color
                            width: 2, // Outline thickness
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundImage: NetworkImage(snapshot.data!),
                        ),
                      );
                    } else {
                      return const CircleAvatar(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    name.when(
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
                                  Text('@$name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        decoration: TextDecoration.underline,
                                        fontSize: 18,
                                      )),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ), // Add an icon
                                ],
                              ),
                            ),
                        loading: () => const Text('Loading...'),
                        error: (error, _) => const Text('Error!')),
                    Text(formattedTimestamp,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        )),
                  ],
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.caption, style: (const TextStyle(fontSize: 16))),
              ],
            ),
          ),
          content,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () {
                        repository.addLikeToPost(post.id, post.userId);
                      },
                    ),
                    likes.when(
                      data: (int count) => Text('$count'),
                      loading: () => const SizedBox.shrink(),
                      error: (e, stack) => const Icon(Icons.error_outline),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(
                width: 20,
                color: Colors.grey,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        if (!disableCommentButton) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostCommentFeed(
                                  auth: FirebaseAuth.instance,
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

  String _formatTime(int milliseconds) {
    int seconds = milliseconds ~/ 1000;
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  Widget _buildRunPost(BuildContext context, String runImageUrl,
      double distance, String time, double pace) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Distribute space evenly
          children: [
            // Distance
            Column(
              children: [
                Icon(
                  Icons.directions_run,
                  color: Theme.of(context).colorScheme.primary,
                ), // Use an appropriate icon
                Text(
                  "${distance.toStringAsFixed(2)} km",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Time
            Column(
              children: [
                Icon(
                  Icons.timer,
                  color: Theme.of(context).colorScheme.primary,
                ), // Use an appropriate icon
                Text(
                  _formatTime(double.parse(time).toInt()),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Pace
            Column(
              children: [
                Icon(
                  Icons.speed,
                  color: Theme.of(context).colorScheme.primary,
                ), // Use an appropriate icon
                Text(
                  "${pace.toStringAsFixed(2)} min/km",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Dialog(
                      child: InteractiveViewer(
                        panEnabled: false,
                        boundaryMargin: const EdgeInsets.all(80),
                        minScale: 0.5,
                        maxScale: 4,
                        child: Image.network(
                          runImageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
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
        ),
      ],
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'with $points points',
                style: TextStyle(
                  fontSize: 18,
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
