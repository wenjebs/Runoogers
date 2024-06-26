import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runningapp/pages/logged_in/training_page/prompt.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

part 'plan_generator.g.dart';

final gemini = Gemini.instance;

@riverpod
Future<Map<String, dynamic>> plan(PlanRef ref) async {
  final user = FirebaseAuth.instance.currentUser!;
  final userId = user.uid;

  // Fetch user-specific data from Firestore
  var userDocument =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  var userData = userDocument.data();
  if (userData == null) {
    throw Exception("User data not found");
  }

  // Initialize Prompt with fetched data
  final prompt = Prompt(
    timesPerWeek: userData['timesPerWeek'] ?? 0,
    targetDistance: userData['targetDistance'] ?? 0,
    targetTime: userData['targetTime'] ?? '',
    weeksToTrain: userData['weeksToTrain'] ?? 0,
  ).prompt;

  // Get the text from the model
  final text = await gemini.text(prompt, modelName: 'models/gemini-pro');

  // Encode it into a json
  final json = jsonDecode(text!.output!) as Map<String, dynamic>;

  return json;
}
