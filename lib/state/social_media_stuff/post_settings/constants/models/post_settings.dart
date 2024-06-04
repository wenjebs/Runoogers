import "package:runningapp/state/social_media_stuff/post_settings/constants/constants.dart";

enum PostSetting {
  allowLikes(
    title: Constants.allowLikesTitle,
    description: Constants.allowLikesDesc,
    storageKey: Constants.allowLikesStorageKey,
  ),

  allowComments(
    title: Constants.allowCommentsTitle,
    description: Constants.allowCommentsDesc,
    storageKey: Constants.allowCommentsStorageKey,
  );

  final String title;
  final String description;
  final String storageKey;
  const PostSetting({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}
