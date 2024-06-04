import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class PostKey {
  static const userId = 'uid';
  static const route = 'route';
  static const message = 'message';
  static const createdAt = 'created_at';
  static const postSettings = 'post_settings';
  static const fileUrl = 'file_url';
  static const originalFileStorageId = 'original_file_storage_id';

  const PostKey._();
}
