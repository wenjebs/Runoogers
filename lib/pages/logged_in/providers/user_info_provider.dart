import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';

final userProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

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

final trainingOnboardedProvider = FutureProvider.autoDispose<bool>((ref) {
  final userAsync = ref.watch(userProvider);
  return userAsync.when(
    data: (user) async {
      if (user == null) {
        return false; // Default value when user is not logged in
      }
      final uid = user.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return doc.data()?['trainingOnboarded'] ?? false;
    },
    loading: () => false, // Default value while loading
    error: (error, stack) => false, // Default value on error
  );
});

final userInformationProvider =
    StreamProvider.autoDispose<Map<String, dynamic>?>((ref) async* {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('User not logged in');
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  yield* userDoc.snapshots().map((snapshot) => snapshot.data());
});
