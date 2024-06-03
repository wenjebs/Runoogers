import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:runningapp/state/social_media_stuff/post_settings/constants/models/post_settings.dart';
import 'package:runningapp/state/social_media_stuff/posts/typedefs/models/post_key.dart';

@immutable
class Post {
  final String postId;
  final String userId;
  final String route;
  final String message;
  final DateTime createdAt;
  final String fileUrl;
  final String originalFileStorageId;
  final Map<PostSetting, bool> postSettings;

  Post({
    required this.postId,
    required Map<String, dynamic> json,
  })  : userId = json[PostKey.userId],
        route = json[PostKey.route],
        message = json[PostKey.message],
        createdAt = (json[PostKey.createdAt] as Timestamp).toDate(),
        fileUrl = json[PostKey.fileUrl],
        originalFileStorageId = json[PostKey.originalFileStorageId],
        postSettings = {
          for (final entry in json[PostKey.postSettings].entries)
            PostSetting.values.firstWhere(
              (element) => element.storageKey == entry.key,
            ): entry.value,
        };
  bool get allowLikes => postSettings[PostSetting.allowLikes] ?? false;
  bool get allowComments => postSettings[PostSetting.allowComments] ?? false;
}
