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

  // Add like to post
  static Future<void> addLikeToPost(String postId, String userId) {
    return database.addLikeToPost(postId, userId);
  }

  // Add like to comment in post
  static Future<void> addLikeToComment(
      String postId, String commentId, String userId) {
    return database.addLikeToComment(postId, commentId, userId);
  }

  // Get runs
  static Future<QuerySnapshot> getRuns(String userId) {
    debugPrint("getting runs");
    return database.getRuns(userId, "runs");
  }

  // Fetch names from user ID
  static Future<String> fetchName(String userId) {
    return database.fetchName(userId);
  }

  // Get friend requests
  static Future<List<String>> getFriendRequests() {
    return database.getFriendRequests();
  }

  static Future<void> sendFriendRequest(String userId) {
    return database.sendFriendRequest(userId);
  }

  static Future<void> acceptFriendRequest(String userId) {
    return database.acceptFriendRequest(userId);
  }

  static Future<void> rejectFriendRequest(String userId) {
    return database.rejectFriendRequest(userId);
  }

  static Future<List<String>> getFriendList() {
    return database.getFriendList();
  }

  static Future<bool> getTrainingOnboarded() {
    return database.getTrainingOnboarded();
  }

  static Future<List<dynamic>> getTrainingPlans() {
    return database.getTrainingPlans();
  }

  // GET USER STATS
  static Future<int> getRunsDone() {
    return database.getRunsDone();
  }

  // UPDATE USER STATS
  static Future<void> incrementTotalDistanceRan(double distance) {
    return database.incrementTotalDistanceRan(distance);
  }

  static Future<void> incrementTotalTimeRan(int time) {
    return database.incrementTotalTimeRan(time);
  }

  static Future<void> incrementRuns() {
    return database.incrementRuns();
  }

  static Future<List<Map<String, dynamic>>> fetchUserAchievements() {
    return database.fetchUserAchievements();
  }

  static Future<List<String>> updateUserAchievements(
      double distance, int time) {
    return database.updateUserAchievements(distance, time);
  }
}
