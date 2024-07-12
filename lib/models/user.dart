import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  final List<String> achievements;
  final String email;
  final String name;
  final String age;
  final List<String> friends;
  final String activeStory;
  final bool onboarded;
  final int points;
  final List<DocumentReference> posts;
  final Map<String, dynamic> runstats;
  final int totalDistanceRan;
  final int totalRuns;
  final int totalTime;
  final bool trainingOnboarded;
  final String uid;
  final String username;

  User({
    this.id = '',
    required this.achievements,
    required this.email,
    required this.name,
    required this.age,
    required this.friends,
    required this.activeStory,
    required this.onboarded,
    required this.points,
    required this.posts,
    required this.runstats,
    required this.totalDistanceRan,
    required this.totalRuns,
    required this.totalTime,
    required this.trainingOnboarded,
    required this.uid,
    required this.username,
  });

  // Constructor to create a User instance from a Firestore document
  User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        achievements = List<String>.from(doc.data()?['achievements'] ?? []),
        email = doc.data()?['email'] ?? '',
        name = doc.data()?['name'] ?? '',
        age = doc.data()?['age'] ?? '',
        friends = List<String>.from(doc.data()?['friends'] ?? []),
        activeStory = doc.data()?['activeStory'] ?? '',
        onboarded = doc.data()?['onboarded'] ?? false,
        points = doc.data()?['points'] ?? 0,
        posts = List<DocumentReference>.from(doc.data()?['posts'] ?? []),
        runstats = doc.data()?['runstats'] ?? {},
        totalDistanceRan = doc.data()?['totalDistanceRan'] ?? 0,
        totalRuns = doc.data()?['totalRuns'] ?? 0,
        totalTime = doc.data()?['totalTime'] ?? 0,
        trainingOnboarded = doc.data()?['trainingOnboarded'] ?? false,
        uid = doc.data()?['uid'] ?? '',
        username = doc.data()?['username'] ?? '';

  // Method to convert a User instance into a Map for uploading to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'achievements': achievements,
      'email': email,
      'name': name,
      'age': age,
      'friends': friends,
      'activeStory': activeStory,
      'onboarded': onboarded,
      'points': points,
      'posts': posts,
      'runstats': runstats,
      'totalDistanceRan': totalDistanceRan,
      'totalRuns': totalRuns,
      'totalTime': totalTime,
      'trainingOnboarded': trainingOnboarded,
      'uid': uid,
      'username': username,
    };
  }

  User copyWith({
    String? id,
    List<String>? achievements,
    String? email,
    String? name,
    String? age,
    List<String>? friends,
    String? activeStory,
    bool? onboarded,
    int? points,
    List<DocumentReference>? posts,
    Map<String, dynamic>? runstats,
    int? totalDistanceRan,
    int? totalRuns,
    int? totalTime,
    bool? trainingOnboarded,
    String? uid,
    String? username,
  }) {
    return User(
      id: id ?? this.id,
      achievements: achievements ?? this.achievements,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      friends: friends ?? this.friends,
      activeStory: activeStory ?? this.activeStory,
      onboarded: onboarded ?? this.onboarded,
      points: points ?? this.points,
      posts: posts ?? this.posts,
      runstats: runstats ?? this.runstats,
      totalDistanceRan: totalDistanceRan ?? this.totalDistanceRan,
      totalRuns: totalRuns ?? this.totalRuns,
      totalTime: totalTime ?? this.totalTime,
      trainingOnboarded: trainingOnboarded ?? this.trainingOnboarded,
      uid: uid ??
          this.uid, // Assuming uid should be copied as well, even though it's not in the provided method signature
      username: username ?? this.username,
    );
  }
}
