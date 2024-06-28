import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserPostService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPosts(List<String> friendUids) {
    return _firestore
        .collection('posts')
        .where('userId', whereIn: friendUids)
        .snapshots();
  }
}
