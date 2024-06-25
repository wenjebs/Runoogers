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

final friendsProvider = StreamProvider.autoDispose<List<String>>((ref) async* {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('User not logged in');
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  yield* userDoc.snapshots().map((snapshot) {
    List<dynamic> friendsList = snapshot.data()?['friends'] ?? [];
    List<String> result =
        friendsList.map((friend) => friend as String).toList();
    result.add(user.uid);
    return result;
  });
});
