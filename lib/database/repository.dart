import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/database/database.dart';

Database db = Database(firestore: FirebaseFirestore.instance);

class Repository {
  final Database database;

  Repository({required this.database});

  Future<void> addData(String collection, Map<String, dynamic> data) {
    // You can add business logic here before saving to database
    return database.addDocument(collection, data);
  }

  Stream<QuerySnapshot> getData(String collection) {
    // You can add business logic here before retrieving data
    return database.streamCollection(collection);
  }

  // Add other methods for update, delete, etc.
}
