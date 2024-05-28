import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runningapp/database/repository.dart';

part 'runs_provider.g.dart';

@riverpod
Future<QuerySnapshot> getRuns(GetRunsRef ref, String userId) async {
  debugPrint("getting runs");
  return await db.getRuns(userId, "runs");
}
