import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/models/route_model.dart';
import 'package:runningapp/models/progress_model.dart';
import 'package:runningapp/models/quests_model.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/story_page/models/story_model.dart';
import 'package:runningapp/pages/login_and_registration/auth_page.dart';
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

  Future<void> logoutAndRedirect(BuildContext context) async {
    try {
      await Authenticator().logOut();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthPage()));
    } catch (error) {
      // Handle logout error, e.g., show an error message.
      print("Logout failed: $error");
    }
  }

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

  Future<User> getUserProfile(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (docSnapshot.exists) {
      User user = User.fromFirestore(docSnapshot);
      return user;
    } else {
      throw Exception("User not found");
    }
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

  Future<String> getTodayTrainingType() async {
    // Format today's date
    final String todayFormatted =
        DateFormat('EEEE, d MMMM').format(DateTime.now());

    try {
      // Retrieve the training plans
      List<dynamic> trainingPlans = await getTrainingPlans();

      // Search for today's date in the training plans
      for (var week in trainingPlans) {
        for (var day in week['daily_schedule']) {
          if (day['day_of_week'] == todayFormatted) {
            // Return the type of day if found
            return day['type'];
          }
        }
      }

      // Return a default value if today's date is not found
      return "Training plan expired";
    } catch (e) {
      // Handle errors, e.g., user not logged in or no training plans found
      return "Error: ${e.toString()}";
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

  Future<List<Map<String, dynamic>>> fetchUserAchievements(
      {String? uid}) async {
    if (uid == null) {
      final userId = auth.userId;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      final userRef = firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      List<String> current =
          List<String>.from(userDoc.data()?['achievements'] ?? []);

      if (current.isEmpty) {
        debugPrint("empty");
        return [];
      }

      final achievementsRef = firestore.collection('achievements');
      final querySnapshot =
          await achievementsRef.where('id', whereIn: current).get();
      for (var doc in querySnapshot.docs) {
        debugPrint(doc.data().toString());
      }
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      final userRef = firestore.collection('users').doc(uid);
      final userDoc = await userRef.get();

      List<String> current =
          List<String>.from(userDoc.data()?['achievements'] ?? []);

      if (current.isEmpty) {
        debugPrint("empty");
        return [];
      }

      final achievementsRef = firestore.collection('achievements');
      final querySnapshot =
          await achievementsRef.where('id', whereIn: current).get();
      for (var doc in querySnapshot.docs) {
        debugPrint(doc.data().toString());
      }
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }
  }

  Future<List<String>> updateUserAchievements(double distance, int time) async {
    debugPrint("achiegemnt start");
    final userId = auth.userId;
    List<String> unlocked = [];

    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final userDoc = await userRef.get();

    List<String> current = List<String>.from(userDoc.data()!['achievements']);

    if (distance > 5 && !current.contains('seasonedRunner')) {
      unlocked.add("Seasoned Runner");
      await userRef.update({
        'achievements': FieldValue.arrayUnion(['seasonedRunner']),
      });
    }

    if ((time / 60000) / distance < 5 && !current.contains('speedyGonzales')) {
      // 1km under 5 minutes achievement
      unlocked.add('Speedy Gonzales');
      await userRef.update({
        'achievements': FieldValue.arrayUnion(['speedyGonzales']),
      });
    }
    debugPrint("achivement done");

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

    friendIds.add(userId);

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

  void updateQuestProgress(double distance, int time, int currQuestID,
      String storyId, BuildContext context) async {
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
      if (!doc.exists) {
        transaction.set(progressRef, {
          'currentQuest': 0,
          'distanceTravelled': 0,
          'questProgress': List.filled(quests.length, 0),
          'questsCompleted': List.filled(quests.length, false),
        });
      }
      var data = doc.data();
      data ??= {
        'currentQuest': 0,
        'distanceTravelled': 0.0,
        'questProgress': List.filled(quests.length, 0.0),
        'questsCompleted': List.filled(quests.length, false),
      };
      int currentQuest = data['currentQuest'];
      final currentDistance = data['distanceTravelled'];
      final currentQuestProgress = data['questProgress'];
      final currentQuestCompletionStatus = data['questsCompleted'];
      // Update current quest progress
      double tracker = distance;
      int storiesCompleted = 0;
      while (tracker >= 0 && currentQuest < quests.length) {
        if (tracker + currentQuestProgress[currentQuest] >=
            quests[currentQuest].distance) {
          double temp = currentQuestProgress[currentQuest].toDouble();
          currentQuestProgress[currentQuest] = quests[currentQuest].distance;
          currentQuestCompletionStatus[currentQuest] = true;
          storiesCompleted += 1;
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

      if (storiesCompleted != 0) {
        await addPoints(storiesCompleted * 2000);
        await showCompletionPopup(context, storiesCompleted);
      }

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

  Future<void> showCompletionPopup(
      BuildContext context, int storiesCompleted) async {
    int pointsEarned =
        storiesCompleted * 2000; // Assuming each story awards 2000 points
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'You have completed $storiesCompleted ${storiesCompleted == 1 ? "story" : "stories"}!'),
                Text('You have earned $pointsEarned points!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> resetQuestsProgress(
    String storyId,
  ) async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final progressRef = userRef.collection('storyProgress').doc(storyId);
    List<Quest> quests = await getQuests(storyId);
    firestore.runTransaction((transaction) async {
      final doc = await transaction.get(progressRef);
      if (!doc.exists) {
        transaction.set(progressRef, {
          'currentQuest': 0,
          'distanceTravelled': 0,
          'questProgress': List.filled(quests.length, 0),
          'questsCompleted': List.filled(quests.length, false),
        });
      } else {
        transaction.update(progressRef, {
          'currentQuest': 0,
          'distanceTravelled': 0,
          'questProgress': List.filled(quests.length, 0),
          'questsCompleted': List.filled(quests.length, false),
        });
      }
    });
  }

  Future<bool> routeExists(String id) {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final routeRef = userRef.collection('routes').doc(id);
    return routeRef.get().then((doc) => doc.exists);
  }

  Future<void> saveRoute(RouteModel route) async {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final routeRef = userRef
        .collection('routes')
        .withConverter(
          fromFirestore: RouteModel.fromFirestore,
          toFirestore: (RouteModel route, options) => route.toFirestore(),
        )
        .doc();
    final id = routeRef.id;
    // check if route already exists using id
    if (await routeExists(id)) {
      throw Exception("Route already exists");
    }
    RouteModel newRoute = route.copyWith(id: id);
    return routeRef.set(newRoute);
  }

  Future<List<RouteModel>> getSavedRoutes() {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    return userRef.collection('routes').get().then((querySnapshot) =>
        querySnapshot.docs
            .map((doc) => RouteModel.fromFirestore(doc, null))
            .toList());
  }

  Future<void> deleteRoute(String getId) {
    final userId = auth.userId;
    if (userId == null) {
      throw Exception("User not logged in");
    }

    final userRef = firestore.collection('users').doc(userId);
    final routeRef = userRef.collection('routes').doc(getId);
    return routeRef.delete();
  }
}
