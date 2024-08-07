// Mocks generated by Mockito 5.4.4 from annotations
// in runningapp/test/route_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:cloud_firestore/cloud_firestore.dart' as _i3;
import 'package:flutter/material.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i10;
import 'package:runningapp/database/database.dart' as _i2;
import 'package:runningapp/database/repository.dart' as _i6;
import 'package:runningapp/models/progress_model.dart' as _i5;
import 'package:runningapp/models/quests_model.dart' as _i12;
import 'package:runningapp/models/route_model.dart' as _i13;
import 'package:runningapp/models/run.dart' as _i9;
import 'package:runningapp/models/user.dart' as _i4;
import 'package:runningapp/pages/logged_in/story_page/models/story_model.dart'
    as _i11;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDocumentSnapshot_1<T extends Object?> extends _i1.SmartFake
    implements _i3.DocumentSnapshot<T> {
  _FakeDocumentSnapshot_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQuerySnapshot_2<T extends Object?> extends _i1.SmartFake
    implements _i3.QuerySnapshot<T> {
  _FakeQuerySnapshot_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserModel_3 extends _i1.SmartFake implements _i4.UserModel {
  _FakeUserModel_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQuestProgressModel_4 extends _i1.SmartFake
    implements _i5.QuestProgressModel {
  _FakeQuestProgressModel_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Repository].
///
/// See the documentation for Mockito's code generation for more information.
class MockRepository extends _i1.Mock implements _i6.Repository {
  @override
  _i2.Database get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.getter(#database),
        ),
        returnValueForMissingStub: _FakeDatabase_0(
          this,
          Invocation.getter(#database),
        ),
      ) as _i2.Database);

  @override
  _i7.Future<void> addData(
    String? collection,
    Map<String, dynamic>? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addData,
          [
            collection,
            data,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Stream<_i3.QuerySnapshot<Object?>> getData(String? collection) =>
      (super.noSuchMethod(
        Invocation.method(
          #getData,
          [collection],
        ),
        returnValue: _i7.Stream<_i3.QuerySnapshot<Object?>>.empty(),
        returnValueForMissingStub:
            _i7.Stream<_i3.QuerySnapshot<Object?>>.empty(),
      ) as _i7.Stream<_i3.QuerySnapshot<Object?>>);

  @override
  _i7.Future<void> logoutAndRedirect(_i8.BuildContext? context) =>
      (super.noSuchMethod(
        Invocation.method(
          #logoutAndRedirect,
          [context],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<_i3.DocumentSnapshot<Map<String, dynamic>>> getUserData(
          String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserData,
          [userId],
        ),
        returnValue:
            _i7.Future<_i3.DocumentSnapshot<Map<String, dynamic>>>.value(
                _FakeDocumentSnapshot_1<Map<String, dynamic>>(
          this,
          Invocation.method(
            #getUserData,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i3.DocumentSnapshot<Map<String, dynamic>>>.value(
                _FakeDocumentSnapshot_1<Map<String, dynamic>>(
          this,
          Invocation.method(
            #getUserData,
            [userId],
          ),
        )),
      ) as _i7.Future<_i3.DocumentSnapshot<Map<String, dynamic>>>);

  @override
  _i7.Future<void> addUser(
    String? collection,
    Map<String, dynamic>? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addUser,
          [
            collection,
            data,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> addRun(
    String? collection,
    _i9.Run? run,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addRun,
          [
            collection,
            run,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> addPost(
    String? collection,
    Map<String, dynamic>? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addPost,
          [
            collection,
            data,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> addLikeToPost(
    String? postId,
    String? userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addLikeToPost,
          [
            postId,
            userId,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> addLikeToComment(
    String? postId,
    String? commentId,
    String? userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addLikeToComment,
          [
            postId,
            commentId,
            userId,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<_i3.QuerySnapshot<Object?>> getRuns(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRuns,
          [userId],
        ),
        returnValue: _i7.Future<_i3.QuerySnapshot<Object?>>.value(
            _FakeQuerySnapshot_2<Object?>(
          this,
          Invocation.method(
            #getRuns,
            [userId],
          ),
        )),
        returnValueForMissingStub: _i7.Future<_i3.QuerySnapshot<Object?>>.value(
            _FakeQuerySnapshot_2<Object?>(
          this,
          Invocation.method(
            #getRuns,
            [userId],
          ),
        )),
      ) as _i7.Future<_i3.QuerySnapshot<Object?>>);

  @override
  _i7.Future<String> fetchName(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #fetchName,
          [userId],
        ),
        returnValue: _i7.Future<String>.value(_i10.dummyValue<String>(
          this,
          Invocation.method(
            #fetchName,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<String>.value(_i10.dummyValue<String>(
          this,
          Invocation.method(
            #fetchName,
            [userId],
          ),
        )),
      ) as _i7.Future<String>);

  @override
  _i7.Future<List<String>> getFriendRequests() => (super.noSuchMethod(
        Invocation.method(
          #getFriendRequests,
          [],
        ),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);

  @override
  _i7.Future<void> sendFriendRequest(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #sendFriendRequest,
          [userId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> acceptFriendRequest(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #acceptFriendRequest,
          [userId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> rejectFriendRequest(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #rejectFriendRequest,
          [userId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<List<String>> getFriendList() => (super.noSuchMethod(
        Invocation.method(
          #getFriendList,
          [],
        ),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);

  @override
  _i7.Future<_i4.UserModel> getUserProfile(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserProfile,
          [userId],
        ),
        returnValue: _i7.Future<_i4.UserModel>.value(_FakeUserModel_3(
          this,
          Invocation.method(
            #getUserProfile,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i4.UserModel>.value(_FakeUserModel_3(
          this,
          Invocation.method(
            #getUserProfile,
            [userId],
          ),
        )),
      ) as _i7.Future<_i4.UserModel>);

  @override
  _i7.Future<bool> getTrainingOnboarded() => (super.noSuchMethod(
        Invocation.method(
          #getTrainingOnboarded,
          [],
        ),
        returnValue: _i7.Future<bool>.value(false),
        returnValueForMissingStub: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);

  @override
  _i7.Future<List<dynamic>> getTrainingPlans() => (super.noSuchMethod(
        Invocation.method(
          #getTrainingPlans,
          [],
        ),
        returnValue: _i7.Future<List<dynamic>>.value(<dynamic>[]),
        returnValueForMissingStub: _i7.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i7.Future<List<dynamic>>);

  @override
  _i7.Future<String> getTodayTrainingType() => (super.noSuchMethod(
        Invocation.method(
          #getTodayTrainingType,
          [],
        ),
        returnValue: _i7.Future<String>.value(_i10.dummyValue<String>(
          this,
          Invocation.method(
            #getTodayTrainingType,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<String>.value(_i10.dummyValue<String>(
          this,
          Invocation.method(
            #getTodayTrainingType,
            [],
          ),
        )),
      ) as _i7.Future<String>);

  @override
  _i7.Future<int> getRunsDone() => (super.noSuchMethod(
        Invocation.method(
          #getRunsDone,
          [],
        ),
        returnValue: _i7.Future<int>.value(0),
        returnValueForMissingStub: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);

  @override
  _i7.Future<void> incrementTotalDistanceRan(double? distance) =>
      (super.noSuchMethod(
        Invocation.method(
          #incrementTotalDistanceRan,
          [distance],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> incrementTotalTimeRan(int? time) => (super.noSuchMethod(
        Invocation.method(
          #incrementTotalTimeRan,
          [time],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> incrementRuns() => (super.noSuchMethod(
        Invocation.method(
          #incrementRuns,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<List<Map<String, dynamic>>> fetchUserAchievements({String? uid}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserAchievements,
          [],
          {#uid: uid},
        ),
        returnValue: _i7.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
        returnValueForMissingStub: _i7.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i7.Future<List<Map<String, dynamic>>>);

  @override
  _i7.Future<List<String>> updateUserAchievements(
    double? distance,
    int? time,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserAchievements,
          [
            distance,
            time,
          ],
        ),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);

  @override
  _i7.Future<void> addPoints(int? points) => (super.noSuchMethod(
        Invocation.method(
          #addPoints,
          [points],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<List<Map<String, dynamic>>> fetchTopUsersGlobal() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchTopUsersGlobal,
          [],
        ),
        returnValue: _i7.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
        returnValueForMissingStub: _i7.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i7.Future<List<Map<String, dynamic>>>);

  @override
  _i7.Future<List<Map<String, dynamic>>> fetchTopUsersFriends() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchTopUsersFriends,
          [],
        ),
        returnValue: _i7.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
        returnValueForMissingStub: _i7.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i7.Future<List<Map<String, dynamic>>>);

  @override
  _i7.Future<List<_i11.Story>> getStories() => (super.noSuchMethod(
        Invocation.method(
          #getStories,
          [],
        ),
        returnValue: _i7.Future<List<_i11.Story>>.value(<_i11.Story>[]),
        returnValueForMissingStub:
            _i7.Future<List<_i11.Story>>.value(<_i11.Story>[]),
      ) as _i7.Future<List<_i11.Story>>);

  @override
  _i7.Future<bool> hasUserCompletedStory(
    String? userId,
    String? storyId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #hasUserCompletedStory,
          [
            userId,
            storyId,
          ],
        ),
        returnValue: _i7.Future<bool>.value(false),
        returnValueForMissingStub: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);

  @override
  _i7.Future<void> setUserActiveStory(
    String? userId,
    String? storyId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setUserActiveStory,
          [
            userId,
            storyId,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<List<_i12.Quest>> getQuests(String? storyId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getQuests,
          [storyId],
        ),
        returnValue: _i7.Future<List<_i12.Quest>>.value(<_i12.Quest>[]),
        returnValueForMissingStub:
            _i7.Future<List<_i12.Quest>>.value(<_i12.Quest>[]),
      ) as _i7.Future<List<_i12.Quest>>);

  @override
  _i7.Future<_i5.QuestProgressModel> getQuestProgress(String? storyId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getQuestProgress,
          [storyId],
        ),
        returnValue:
            _i7.Future<_i5.QuestProgressModel>.value(_FakeQuestProgressModel_4(
          this,
          Invocation.method(
            #getQuestProgress,
            [storyId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i5.QuestProgressModel>.value(_FakeQuestProgressModel_4(
          this,
          Invocation.method(
            #getQuestProgress,
            [storyId],
          ),
        )),
      ) as _i7.Future<_i5.QuestProgressModel>);

  @override
  void updateQuestProgress(
    double? distance,
    int? time,
    int? currQuestID,
    String? storyId,
    _i8.BuildContext? context,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #updateQuestProgress,
          [
            distance,
            time,
            currQuestID,
            storyId,
            context,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i7.Future<void> resetQuestsProgress(String? storyId) => (super.noSuchMethod(
        Invocation.method(
          #resetQuestsProgress,
          [storyId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> saveRoute(_i13.RouteModel? route) => (super.noSuchMethod(
        Invocation.method(
          #saveRoute,
          [route],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<List<_i13.RouteModel>> getSavedRoutes() => (super.noSuchMethod(
        Invocation.method(
          #getSavedRoutes,
          [],
        ),
        returnValue:
            _i7.Future<List<_i13.RouteModel>>.value(<_i13.RouteModel>[]),
        returnValueForMissingStub:
            _i7.Future<List<_i13.RouteModel>>.value(<_i13.RouteModel>[]),
      ) as _i7.Future<List<_i13.RouteModel>>);

  @override
  void deleteRoute(String? getId) => super.noSuchMethod(
        Invocation.method(
          #deleteRoute,
          [getId],
        ),
        returnValueForMissingStub: null,
      );
}
