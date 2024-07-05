import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/story_page/models/progress_model.dart';
import 'package:runningapp/pages/logged_in/story_page/models/quests_model.dart';
import 'package:runningapp/pages/logged_in/story_page/models/story_model.dart';
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

  ///////////////////////////////////////
  /// RUN METHODS
  /// //////////////////////////////////

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

  // Get runs
  Future<QuerySnapshot> getRuns(String userId, String collection) {
    return firestore
        .collection("users")
        .doc(userId)
        .collection(collection)
        .get();
  }

  //////////////////////////////////////////
  /// SOCIAL MEDIA METHODS
  /// //////////////////////////////////////

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

  ///////////////////////////////////////
  /// TRAINING METHODS
  ///////////////////////////////////////

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
      List<dynamic> trainingPlan = data['running_plan']['weeks'];
      return trainingPlan;
    } else {
      // Handle the case where the collection does not exist or has no documents
      return [];
    }
  }

  ////////////////////////////////////////
  /// ACHIEVEMENT / STATS METHODS
  ////////////////////////////////////////

  Future<void> incrementTotalDistanceRan(double distance) {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);

    return firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);
      final currentDistance = doc.data()?['totalDistanceRan'] ?? 0;
      transaction.update(userRef, {
        'totalDistanceRan': currentDistance + distance,
      });
    });
  }

  Future<void> incrementTotalTimeRan(int time) {
    // in ms
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    return firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);
      final currentTime = doc.data()?['totalTime'] ?? 0;
      transaction.update(userRef, {
        'totalTime': currentTime + time,
      });
    });
  }

  Future<void> incrementRuns() {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    return firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);
      final currentRuns = doc.data()?['totalRuns'] ?? 0;
      transaction.update(userRef, {
        'totalRuns': currentRuns + 1,
      });
    });
  }

  Future<int> getRunsDone() {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    return userRef.get().then((doc) {
      return doc.data()?['totalRuns'] ?? 0;
    });
  }

  Future<void> storeImageUrl(String imageUrl) async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    var documentReference =
        FirebaseFirestore.instance.collection('users').doc();
    await documentReference.set({
      'imageUrl': imageUrl,
      // Add other run details here
    });
  }

  ///////////////////////////////////////
  /// GAMIFICATION / ACHIEVEMENT RELATED
  ///////////////////////////////////////

  Future<List<Map<String, dynamic>>> fetchUserAchievements() async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userAchievementsRef =
        firestore.collection('users').doc(userId).collection('achievements');
    final querySnapshot = await userAchievementsRef.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<String>> updateUserAchievements(double distance, int time) async {
    final userId = auth.userId;
    List<String> unlocked = [];

    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);

    if (distance > 5) {
      // 5km achievement
      final achievementRef = firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('5km');

      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(achievementRef);
        final userDoc = await transaction.get(userRef);

        if (!doc.exists && userDoc.exists) {
          transaction.set(achievementRef, {
            'name': 'Seasoned Runner',
            'description': 'Run your first 5km run!',
            'points': 5000,
            'picture':
                'https://img.freepik.com/free-vector/award-medal-realistic-composition-with-isolated-image-medal-with-laurel-wreath-blank-background-vector-illustration_1284-66109.jpg?size=626&ext=jpg&ga=GA1.1.1141335507.1719273600&semt=ais_user',
          });

          final userPoints = userDoc.data()!['points'];
          transaction.update(userRef, {'points': userPoints + 5000});

          unlocked.add('Seasoned Runner');
        }
      });
    }

    if ((time / 60000) / distance < 5) {
      // 1km under 5 minutes achievement
      final achievementRef = firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('1kmUnder5Minutes');

      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(achievementRef);
        final userDoc = await transaction.get(userRef);
        if (!doc.exists && userDoc.exists) {
          transaction.set(achievementRef, {
            'name': 'Speedy Gonzales',
            'description': 'Run 1km under 5 minutes!',
            'points': 3000,
            'picture': 'https://m.media-amazon.com/images/I/71wRDvtAJLL.jpg',
          });

          final userPoints = userDoc.data()!['points'];
          transaction.update(userRef, {'points': userPoints + 3000});
          unlocked.add('Speedy Gonzales');
        }
      });
    }

    return unlocked;
  }

  Future<void> addPoints(int points) {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    return firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userRef);
      final currentPoints = doc.data()?['points'] ?? 0;
      transaction.update(userRef, {
        'points': currentPoints + points,
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchTopUsersGlobal() async {
    final querySnapshot = await firestore
        .collection('users')
        .orderBy('points', descending: true)
        .limit(100)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchTopUsersFriends() async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final List<String> friendIds = await getFriendList();

    final List<Map<String, dynamic>> friendsData = [];
    for (String friendId in friendIds) {
      final doc = await firestore.collection('users').doc(friendId).get();
      if (doc.exists) {
        friendsData.add(doc.data() as Map<String, dynamic>);
      }
    }
    friendsData.sort((a, b) => (b['points'] ?? 0).compareTo(a['points'] ?? 0));

    return friendsData.take(100).toList();
  }

  ///////////////////////////////////////
  /// STORY RELATED
  ///////////////////////////////////////
  Future<List<Story>> getUserStories() async {
    final snapshot = await firestore.collection('stories').get();

    return snapshot.docs
        .map((doc) => Story.fromFirestore(
              doc.data(),
            ))
        .toList();
  }

  Future<bool> hasUserCompletedStory(String userId, String storyId) async {
    final storyRef = firestore.collection('stories').doc(storyId);
    final doc = await storyRef.get();

    if (!doc.exists) {
      throw Exception("Story does not exist");
    }

    // Assuming the document has a field 'completedBy' which is a list of user IDs who have completed the story
    List<dynamic> completedBy = doc.data()?['completedBy'] ?? [];
    return completedBy.contains(userId);
  }

  Future<void> setUserActiveStory(String userId, String storyId) {
    final userRef = firestore.collection('users').doc(userId);
    return userRef.update({'activeStory': storyId});
  }

  // returns a list of maps containing the quests completed by each user
  // list is in quest order [quest1, quest2, ...]
  // each quest is a map {description: ..., title: ..., distance: ...,}
  Future<List<Quest>> getQuests(String storyId) async {
    if (storyId == "") {
      return List<Quest>.empty();
    }
    final storyRef = firestore.collection('stories').doc(storyId);
    final doc = await storyRef.get();

    if (!doc.exists) {
      throw Exception("Story does not exist");
    }

    // Assuming the document has a field 'quests' which is a list of quests
    List<dynamic> questsData = doc.data()?['quests'] ?? [];
    List<Quest> quests = questsData
        .cast<Map<String, dynamic>>()
        .map((questData) => Quest.fromFirestore(questData))
        .toList();
    return quests;
  }

  Future<QuestProgressModel> getQuestProgress(String storyId) async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }
    if (storyId == "") {
      return QuestProgressModel(
        currentQuest: 0,
        distanceTravelled: 0,
        questCompletionStatus: List.filled(0, false),
        questDistanceProgress: List.filled(0, 0),
      );
    }
    int noOfQuests = await getQuests(storyId).then((value) => value.length);
    final progressRef = firestore
        .collection('users')
        .doc(userId)
        .collection('storyProgress')
        .doc(storyId);
    // If story progress is stored in a document
    final doc = await progressRef.get();
    // debugPrint("GETQUESTPROGRESS" + doc.data().toString());
    if (doc.exists) {
      final data = doc.data();
      return QuestProgressModel.fromFirestore(data!);
    } else {
      return QuestProgressModel(
        currentQuest: 0,
        distanceTravelled: 0,
        questCompletionStatus: List.filled(noOfQuests, false),
        questDistanceProgress: List.filled(noOfQuests, 0),
      );
    }
  }

  Future<void> updateQuestProgress(
    double distance,
    int time,
    int currQuestID,
    String storyId,
  ) async {
    debugPrint("Repository: updating quest progress");
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final progressRef = userRef.collection('storyProgress').doc(storyId);
    List<Quest> quests = await getQuests(storyId);
    firestore.runTransaction((transaction) async {
      final doc = await transaction.get(progressRef);
      final data = doc.data();
      int currentQuest = data?['currentQuest'];
      final currentDistance = data?['distanceTravelled'];
      final currentQuestProgress = data?['questProgress'];
      final currentQuestCompletionStatus = data?['questsCompleted'];
      // Update current quest progress
      double tracker = distance;
      while (tracker >= 0 && currentQuest < quests.length) {
        if (tracker + currentQuestProgress[currentQuest] >=
            quests[currentQuest].distance) {
          double temp = currentQuestProgress[currentQuest].toDouble();
          currentQuestProgress[currentQuest] = quests[currentQuest].distance;
          currentQuestCompletionStatus[currentQuest] = true;
          tracker -= (quests[currentQuest].distance - temp);
          currentQuest++;
        } else {
          currentQuestProgress[currentQuest] += tracker;
          tracker = -1;
        }
      }
      // Update distance travelled
      transaction.update(
        progressRef,
        {
          'distanceTravelled': currentDistance + distance,
          'currentQuest': currentQuest,
          'questProgress': currentQuestProgress,
          'questsCompleted': currentQuestCompletionStatus,
        },
      );

      // // Update quest progress
      // for (int i = 0; i < currentQuestProgress.length; i++) {
      //   if (!currentQuestCompletionStatus[i]) {
      //     currentQuestProgress[i] += distance;
      //     if (currentQuestProgress[i] >= 1000) {
      //       currentQuestCompletionStatus[i] = true;
      //     }
      //   }
      // }
    });
  }
}
