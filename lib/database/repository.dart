import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/database.dart';
import 'package:runningapp/models/run.dart';

Database db = Database(firestore: FirebaseFirestore.instance);

// this class is an adaptor to any database
class Repository {
  static final Database database = db;

  static Future<void> addData(String collection, Map<String, dynamic> data) {
    // You can add business logic here before saving to database
    return database.addDocument(collection, data);
  }

  static Stream<QuerySnapshot> getData(String collection) {
    // You can add business logic here before retrieving data
    return database.streamCollection(collection);
  }

  // Add user
  static Future<void> addUser(String collection, Map<String, dynamic> data) {
    return database.addUser(collection, data);
  }

  // Add run
  static Future<void> addRun(String collection, Run run) {
    debugPrint("Adding run to database");
    return database.addRun(collection, run);
  }

  // Add post
  static Future<void> addPost(String collection, Map<String, dynamic> data) {
    return database.addPost(collection, data);
  }

  // Get runs
  static Future<QuerySnapshot> getRuns(String userId) {
    debugPrint("getting runs");
    return database.getRuns(userId, "runs");
  }
}
