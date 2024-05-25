import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({required this.firestore});

  Future<void> addDocument(String collection, Map<String, dynamic> data) {
    return firestore.collection(collection).add(data);
  }

  Stream<QuerySnapshot> streamCollection(String collection) {
    return firestore.collection(collection).snapshots();
  }

  // Add other methods for update, delete, etc.
}
