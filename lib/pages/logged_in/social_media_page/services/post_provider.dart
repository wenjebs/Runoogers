import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final likesCountProvider = StreamProvider.family<int, String>((ref, postId) {
  return FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('likes')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});

final userNameProvider = FutureProvider.family<String, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get()
      .then((snapshot) => snapshot.data()?['username'] ?? 'Unknown User');
});

final commentsCountProvider = StreamProvider.family<int, String>((ref, postId) {
  return FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});
// TODO when a like is added, increment "likes" count in the post document
final commentsLikeProvider =
    StreamProvider.family<int, Map<String, String>>((ref, ids) {
  final postId = ids['postId']!;
  final commentId = ids['commentId']!;

  return FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('comments')
      .doc(commentId)
      .collection('likes')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.length;
  }).handleError((error) {
    debugPrint('Error: $error');
    return 0;
  });
});

final commentControllerProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
