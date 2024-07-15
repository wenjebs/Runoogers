class Post {
  final String id;
  final String userId;
  final String caption;
  final int likes;

  // if its an achievement post
  final String? achievementDescription;
  final String? achievementTitle;
  final String? achievementImageUrl;
  final int? achievementPoints;

  // if its a run post
  final String? runImageUrl;

  // TODO implement story post

  Post({
    required this.id,
    required this.userId,
    required this.caption,
    required this.likes,
    this.achievementDescription,
    this.achievementTitle,
    this.achievementImageUrl,
    this.achievementPoints,
    this.runImageUrl,
  });

  // You can add methods here to help identify the type of post, e.g.,
  bool get isAchievementPost => achievementDescription != null;
  bool get isRunPost => runImageUrl != null;
  // bool get isStoryPost => story != null;
  bool get isCaptionOnlyPost =>
      runImageUrl == null && achievementDescription == null;

  // Add any other methods or logic as needed
}
