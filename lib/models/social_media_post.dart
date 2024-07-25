import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String caption;
  final int likes;
  final Timestamp timestamp;

  // if its an achievement post
  final String? achievementDescription;
  final String? achievementTitle;
  final String? achievementImageUrl;
  final int? achievementPoints;

  // if its a run post
  final String? runImageUrl;
  final double? runDistance;
  final double? runDuration;
  final double? runPace;

  // if its a leaderboard post
  final int? rank;
  final int? leaderboardPoints;
  final String? username;

  // TODO implement story post

  Post({
    required this.id,
    required this.userId,
    required this.caption,
    required this.likes,
    required this.timestamp,
    this.achievementDescription,
    this.achievementTitle,
    this.achievementImageUrl,
    this.achievementPoints,
    this.runImageUrl,
    this.runDistance,
    this.runDuration,
    this.runPace,
    this.rank,
    this.leaderboardPoints,
    this.username,
  });

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      caption: data['caption'] ?? '',
      likes: data['likes'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
      achievementDescription:
          data['achievementDescription'], // No need for ??, null is acceptable
      achievementTitle:
          data['achievementTitle'], // Assuming these can also be null
      achievementImageUrl: data['achievementImageUrl'],
      achievementPoints: data['achievementPoints'],
      runImageUrl: data['runImageUrl'],
      runDistance: data['runDistance'].toDouble(),
      runDuration: data['runDuration'].toDouble(),
      runPace: data['runPace'],
      rank: data['rank'],
      leaderboardPoints: data['points'],
      username: data['username'],
    );
  }

  // You can add methods here to help identify the type of post, e.g.,
  bool get isAchievementPost => achievementDescription != null;
  bool get isRunPost => runImageUrl != null;
  bool get isLeaderboardPost => rank != null;
  // bool get isStoryPost => story != null;
  bool get isCaptionOnlyPost =>
      runImageUrl == null && achievementDescription == null && rank == null;
}
