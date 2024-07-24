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
    this.rank,
    this.leaderboardPoints,
    this.username,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      userId: map['userId'] as String,
      caption: map['caption'] as String,
      likes: map['likes'] as int,
      timestamp: map['timestamp'],
      achievementDescription: map['achievementDescription'] as String?,
      achievementTitle: map['achievementTitle'] as String?,
      achievementImageUrl: map['achievementImageUrl'] as String?,
      achievementPoints: map['achievementPoints'] as int?,
      runImageUrl: map['runImageUrl'] as String?,
      rank: map['rank'] as int?,
      leaderboardPoints: map['leaderboardPoints'] as int?,
      username: map['username'] as String?,
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
