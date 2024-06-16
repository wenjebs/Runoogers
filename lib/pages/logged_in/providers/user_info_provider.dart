import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';

final userProvider =
    Provider<User?>((ref) => FirebaseAuth.instance.currentUser);

final userInfoProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  final user = ref.watch(userProvider);
  if (user != null) {
    return GetUserPostService().getPosts(["oRzn1b8M3mN1322UewNXF0TCGBx1"]);
  }
  return const Stream.empty();
});
