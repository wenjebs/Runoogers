import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/post_json_stuff.dart';

class GetUserPostService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPosts(List<String> friendUids) {
    return _firestore
        .collection('posts')
        .where('uid', whereIn: friendUids)
        .snapshots();
  }
}
