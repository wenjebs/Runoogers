import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/database.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/models/route_model.dart';
import 'package:runningapp/models/progress_model.dart';
import 'package:runningapp/models/quests_model.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/story_page/models/story_model.dart';

Database db = Database(firestore: FirebaseFirestore.instance);

// this class is an adaptor to any database
class Repository {
  final Database database = db;

  Future<void> addData(String collection, Map<String, dynamic> data) {
    // You can add business logic here before saving to database
    return database.addDocument(collection, data);
  }

  Stream<QuerySnapshot> getData(String collection) {
    // You can add business logic here before retrieving data
    return database.streamCollection(collection);
  }

  Future<void> logoutAndRedirect(BuildContext context) {
    return database.logoutAndRedirect(context);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String userId) {
    // You can add business logic here before retrieving data
    return database.fetchUser(userId);
  }

  Future<String> fetchUsername(String userId) async {
    return database.fetchUsername(userId);
  }

  // Add user
  Future<void> addUser(String collection, Map<String, dynamic> data) {
    return database.addUser(collection, data);
  }

  // Add run
  Future<void> addRun(String collection, Run run) {
    // debugPrint("Adding run to database");
    return database.addRun(collection, run);
  }

  // Add post
  Future<void> addPost(String collection, Map<String, dynamic> data) {
    return database.addPost(collection, data);
  }

  // Add like to post
  Future<void> addLikeToPost(String postId, String userId) {
    return database.addLikeToPost(postId, userId);
  }

  // Add like to comment in post
  Future<void> addLikeToComment(
      String postId, String commentId, String userId) {
    return database.addLikeToComment(postId, commentId, userId);
  }

  // Get runs
  Future<QuerySnapshot> getRuns(String userId) {
    debugPrint("getting runs");
    return database.getRuns(userId, "runs");
  }

  // Fetch names from user ID
  Future<String> fetchName(String userId) {
    return database.fetchName(userId);
  }

  // Get friend requests
  Future<List<String>> getFriendRequests() {
    return database.getFriendRequests();
  }

  // Send friend request
  Future<void> sendFriendRequest(String userId) {
    return database.sendFriendRequest(userId);
  }

  // Accept friend request
  Future<void> acceptFriendRequest(String userId) {
    return database.acceptFriendRequest(userId);
  }

  // Reject friend request
  Future<void> rejectFriendRequest(String userId) {
    return database.rejectFriendRequest(userId);
  }

  // Get friend list
  Future<List<String>> getFriendList() {
    return database.getFriendList();
  }

  // Get user profile
  Future<UserModel> getUserProfile(String userId) {
    return database.getUserProfile(userId);
  }

  // Get training related data
  Future<bool> getTrainingOnboarded() {
    return database.getTrainingOnboarded();
  }

  // Set training related data
  Future<List<dynamic>> getTrainingPlans() {
    return database.getTrainingPlans();
  }

  Future<String> getTodayTrainingType() {
    return database.getTodayTrainingType();
  }

  // Get runs completed
  Future<int> getRunsDone() {
    return database.getRunsDone();
  }

  // Increment total distance run
  Future<void> incrementTotalDistanceRan(double distance) {
    return database.incrementTotalDistanceRan(distance);
  }

  // Increment total time run
  Future<void> incrementTotalTimeRan(int time) {
    return database.incrementTotalTimeRan(time);
  }

  // Increment total runs
  Future<void> incrementRuns() {
    return database.incrementRuns();
  }

  // Get all unlocked achievements
  Future<List<Map<String, dynamic>>> fetchUserAchievements({String? uid}) {
    return database.fetchUserAchievements(uid: uid);
  }

  // Update user achievements
  Future<List<String>> updateUserAchievements(double distance, int time) {
    return database.updateUserAchievements(distance, time);
  }

  // Add points
  Future<void> addPoints(int points) {
    return database.addPoints(points);
  }

  // Fetch global leaderboard
  Future<List<Map<String, dynamic>>> fetchTopUsersGlobal() {
    return database.fetchTopUsersGlobal();
  }

  // Fetch friends leaderboard
  Future<List<Map<String, dynamic>>> fetchTopUsersFriends() {
    return database.fetchTopUsersFriends();
  }

  //  Get stories
  Future<List<Story>> getStories() {
    return database.getUserStories();
  }
  // Each story has a title, shortTitle, description and imageURL

  // Check if user completed story
  Future<bool> hasUserCompletedStory(String userId, String storyId) {
    return database.hasUserCompletedStory(userId, storyId);
  }

  Future<void> setUserActiveStory(String userId, String storyId) {
    return database.setUserActiveStory(userId, storyId);
  }

  Future<List<Quest>> getQuests(String storyId) {
    // debugPrint("Repository: getting quests");
    return database.getQuests(storyId);
  }

  // get users quest progress for a story
  Future<QuestProgressModel> getQuestProgress(String storyId) {
    return database.getQuestProgress(storyId);
  }

  void updateQuestProgress(double distance, int time, int currQuestID,
      String storyId, BuildContext context) {
    database.updateQuestProgress(distance, time, currQuestID, storyId, context);
  }

  Future<void> resetQuestsProgress(
    String storyId,
  ) async {
    debugPrint("Repository: resetting quests progress");
    await database.resetQuestsProgress(storyId);
  }

  /////////////////////
  /// Route saving logic
  /////////////////////
  // Save route
  Future<void> saveRoute(RouteModel route) {
    return database.saveRoute(route);
  }

  // Get saved routes
  Future<List<RouteModel>> getSavedRoutes() {
    return database.getSavedRoutes();
  }

  void deleteRoute(String getId) {
    database.deleteRoute(getId);
  }

  Future<String> fetchProfilePic(String userId) async {
    return database.fetchProfilePic(userId);
  }
}
