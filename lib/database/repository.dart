import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/database.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/story_page/models/quests_model.dart';
import 'package:runningapp/pages/logged_in/story_page/models/story_model.dart';

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
    // debugPrint("Adding run to database");
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

  // Send friend request
  static Future<void> sendFriendRequest(String userId) {
    return database.sendFriendRequest(userId);
  }

  // Accept friend request
  static Future<void> acceptFriendRequest(String userId) {
    return database.acceptFriendRequest(userId);
  }

  // Reject friend request
  static Future<void> rejectFriendRequest(String userId) {
    return database.rejectFriendRequest(userId);
  }

  // Get friend list
  static Future<List<String>> getFriendList() {
    return database.getFriendList();
  }

  // Get training related data
  static Future<bool> getTrainingOnboarded() {
    return database.getTrainingOnboarded();
  }

  // Set training related data
  static Future<List<dynamic>> getTrainingPlans() {
    return database.getTrainingPlans();
  }

  // Get runs completed
  static Future<int> getRunsDone() {
    return database.getRunsDone();
  }

  // Increment total distance run
  static Future<void> incrementTotalDistanceRan(double distance) {
    return database.incrementTotalDistanceRan(distance);
  }

  // Increment total time run
  static Future<void> incrementTotalTimeRan(int time) {
    return database.incrementTotalTimeRan(time);
  }

  // Increment total runs
  static Future<void> incrementRuns() {
    return database.incrementRuns();
  }

  // Get all unlocked achievements
  static Future<List<Map<String, dynamic>>> fetchUserAchievements() {
    return database.fetchUserAchievements();
  }

  // Update user achievements
  static Future<List<String>> updateUserAchievements(
      double distance, int time) {
    return database.updateUserAchievements(distance, time);
  }

  // Add points
  static Future<void> addPoints(int points) {
    return database.addPoints(points);
  }

  // Fetch global leaderboard
  static Future<List<Map<String, dynamic>>> fetchTopUsersGlobal() {
    return database.fetchTopUsersGlobal();
  }

  // Fetch friends leaderboard
  static Future<List<Map<String, dynamic>>> fetchTopUsersFriends() {
    return database.fetchTopUsersFriends();
  }

  //  Get stories
  static Future<List<Story>> getStories() {
    return database.getUserStories();
  }
  // Each story has a title, shortTitle, description and imageURL

  // Check if user completed story
  static Future<bool> hasUserCompletedStory(String userId, String storyId) {
    return database.hasUserCompletedStory(userId, storyId);
  }

  static Future<void> setUserActiveStory(String userId, String storyId) {
    return database.setUserActiveStory(userId, storyId);
  }

  static Future<List<Quest>> getQuests(String storyId) {
    // debugPrint("Repository: getting quests");
    return database.getQuests(storyId);
  }
}
