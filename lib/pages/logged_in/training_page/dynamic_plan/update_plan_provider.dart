import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/pages/logged_in/training_page/dynamic_plan/reprompt.dart';

final geminiProvider = Provider((ref) => Gemini.instance);

final updatePlanProvider = FutureProvider<void>((ref) async {
  final gemini = ref.watch(geminiProvider);
  final user = FirebaseAuth.instance.currentUser!;
  final userId = user.uid;

  var planSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('trainingPlans')
      .limit(1)
      .get();
  var planDocuments = planSnapshot.docs;
  if (planDocuments.isEmpty) {
    throw Exception("Training plan not found");
  }
  var currentPlanJson = planDocuments.first.data();

  var userDocument =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  var userData = userDocument.data();
  if (userData == null) {
    throw Exception("User data not found");
  }

  final currentPlanString = jsonEncode(currentPlanJson);
  final averageDifficulty = userData['averageDifficulty'] / 3.0 ?? 0.0;

  if (averageDifficulty <= 2.5 || averageDifficulty >= 3.5) {
    final newPrompt = Reprompt(
            originalPlanJson: currentPlanString,
            averageDifficulty: averageDifficulty)
        .prompt;

    final textResponse =
        await gemini.text(newPrompt, modelName: 'models/gemini-pro');
    debugPrint(textResponse!.output!);
    final newPlanJson =
        jsonDecode(textResponse.output!) as Map<String, dynamic>;

    debugPrint(newPlanJson.toString());

    var collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('trainingPlans');
    var snapshots = await collectionRef.get();

    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('trainingPlans')
        .add(newPlanJson);
  }
});
