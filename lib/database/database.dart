import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class Database {
  final FirebaseFirestore firestore;
  final Authenticator auth = Authenticator();

  Database({required this.firestore});

  Future<void> addDocument(String collection, Map<String, dynamic> data) {
    return firestore.collection(collection).add(data);
  }

  Stream<QuerySnapshot> streamCollection(String collection) {
    return firestore.collection(collection).snapshots();
  }

  // Add other methods for update, delete, etc.

  // Add user
  Future<void> addUser(String collection, Map<String, dynamic> data) async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }
    debugPrint(userId);
    await firestore.collection(collection).doc(userId).set(data);
  }

  // Fetch names
  Future<String> fetchName(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    return doc['name'];
  }

  // Add run
  Future<void> addRun(String collection, Run run) async {
    final userId = auth.userId;
    // debugPrint(userId);
    if (userId == null) {
      throw Exception("User not logged in");
    }
    final ref = firestore
        .collection("users")
        .doc(userId)
        .collection("runs")
        .withConverter(
            fromFirestore: Run.fromFirestore,
            toFirestore: (Run run, options) => run.toFirestore())
        .doc();
    final id = ref.id;
    Run newRun = run.copyWith(id: id);
    await ref.set(newRun);
  }

  // Add post
  Future<void> addPost(String collection, Map<String, dynamic> data) async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    // adding post to posts main collection
    final ref = firestore.collection(collection).doc();
    final id = ref.id;
    await ref.set({
      'id': id,
      ...data,
    });

    // adding the above post's reference to the users document
    final userRef = firestore.collection('users').doc(userId);
    await userRef.update({
      'posts': FieldValue.arrayUnion([ref]),
    });
  }

  // Get friend list
  Future<List<String>> getFriendList() async {
    final userId = auth.userId;
    final userRef = firestore.collection('users').doc(userId);
    final doc = await userRef.get();
    final friends = doc.data()?['friends'];

    if (friends is List) {
      return List<String>.from(friends);
    } else {
      return [];
    }
  }

  // Add like to post
  Future<void> addLikeToPost(String postId, String userId) async {
    final DocumentReference postRef = firestore.collection('posts').doc(postId);
    final DocumentReference likeRef = postRef.collection('likes').doc(userId);

    return firestore.runTransaction((transaction) async {
      final likeSnapshot = await transaction.get(likeRef);

      if (likeSnapshot.exists) {
        // If like exists, unlike the post
        transaction.delete(likeRef);
      } else {
        // If like does not exist, like the post
        transaction.set(likeRef, {
          'liked': true,
          'userId': userId,
          // 'timestamp':
          //     FieldValue.serverTimestamp(), // Optional: Add a timestamp
        });
      }
    });
  }

  // Add like to comment
  Future<void> addLikeToComment(
      String postId, String commentId, String userId) {
    final DocumentReference commentRef = firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);
    final DocumentReference likeRef =
        commentRef.collection('likes').doc(userId);

    return firestore.runTransaction((transaction) async {
      final likeSnapshot = await transaction.get(likeRef);

      if (likeSnapshot.exists) {
        // If like exists, unlike the comment
        transaction.delete(likeRef);
      } else {
        // If like does not exist, like the comment
        transaction.set(likeRef, {
          'liked': true,
          'userId': userId,
          // 'timestamp':
          //     FieldValue.serverTimestamp(), // Optional: Add a timestamp
        });
      }
    });
  }

  // Send friend request
  Future<void> sendFriendRequest(String userId) async {
    final currentUserId = auth.userId;
    if (currentUserId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);

    await userRef.set({
      'friendRequests': FieldValue.arrayUnion([currentUserId])
    }, SetOptions(merge: true));
  }

  // Get friend requests
  Future<List<String>> getFriendRequests() async {
    final currentUserId = auth.userId;
    if (currentUserId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(currentUserId);
    final doc = await userRef.get();
    final friendRequests = doc.data()?['friendRequests'];

    if (friendRequests is List) {
      return List<String>.from(friendRequests);
    } else {
      return [];
    }
  }

  // Accept friend request
  Future<void> acceptFriendRequest(String userId) async {
    final currentUserId = auth.userId;
    if (currentUserId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final currentUserRef = firestore.collection('users').doc(currentUserId);

    await firestore.runTransaction((transaction) async {
      // Remove the current user's ID from the friendRequests field of the user who sent the request
      transaction.update(userRef, {
        'friendRequests': FieldValue.arrayRemove([currentUserId]),
        'friends':
            FieldValue.arrayUnion([currentUserId]), // Also add to friends list
      });

      // Add the friend's user ID to the friends array field of the current user
      transaction.update(currentUserRef, {
        'friendRequests': FieldValue.arrayRemove([userId]),
        'friends': FieldValue.arrayUnion([userId]),
      });
    });
  }

  // Reject friend request
  Future<void> rejectFriendRequest(String userId) async {
    final currentUserId = auth.userId;
    if (currentUserId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final currentUserRef = firestore.collection('users').doc(currentUserId);

    await firestore.runTransaction((transaction) async {
      // Remove the current user's ID from the friendRequests field of the user who sent the request
      transaction.update(userRef, {
        'friendRequests': FieldValue.arrayRemove([currentUserId]),
      });

      // Remove the friend's user ID from the friendRequests field of the current user
      transaction.update(currentUserRef, {
        'friendRequests': FieldValue.arrayRemove([userId]),
      });
    });
  }

  // Get runs
  Future<QuerySnapshot> getRuns(String userId, String collection) {
    return firestore
        .collection("users")
        .doc(userId)
        .collection(collection)
        .get();
  }

  // Get training onboarded status
  Future<bool> getTrainingOnboarded() async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final doc = await userRef.get();
    return doc.data()?['trainingOnboarded'] ?? false;
  }

  // Get training plan
  Future<List<dynamic>> getTrainingPlans() async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final querySnapshot =
        await userRef.collection('trainingPlans').limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      Map<String, dynamic> data = doc.data();
      // Assuming the document has a field 'trainingPlan' which is a list
      List<dynamic> trainingPlan = data['trainingPlan'];
      return trainingPlan;
    } else {
      // Handle the case where the collection does not exist or has no documents
      return [];
    }
  }
}
