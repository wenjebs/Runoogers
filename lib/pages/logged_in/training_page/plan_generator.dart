import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runningapp/pages/logged_in/training_page/prompt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/state/auth/constants/constants.dart';

part 'plan_generator.g.dart';

final gemini = Gemini.instance;

String getFormattedTodayDate() {
  final now = DateTime.now();
  final formatter = DateFormat('EEEE, d MMMM');
  return formatter.format(now);
}

String getFormattedTomorrowDate() {
  final tomorrow = DateTime.now().add(const Duration(days: 1));
  final formatter = DateFormat('EEEE, d MMMM');
  return formatter.format(tomorrow);
}

String getFormattedDayAfterTomorrowDate() {
  final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));
  final formatter = DateFormat('EEEE, d MMMM');
  return formatter.format(dayAfterTomorrow);
}

@riverpod
Future<Map<String, dynamic>?> plan(PlanRef ref) async {
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
    age: userData['age'] ?? 0,
    level: userData['level'] ?? '',
    todaysDate: getFormattedTodayDate(),
    tomorrowsDate: getFormattedTomorrowDate(),
    dayAfterTomorrowsDate: getFormattedDayAfterTomorrowDate(),
  ).prompt;

  int maxAttempts = 3;
  int attempts = 0;

  // Encode it into a json
  while (attempts < maxAttempts) {
    try {
      debugPrint("generating $attempts");
      final text = await gemini.text(prompt, modelName: 'models/gemini-pro');
      debugPrint(text!.output!);
      final json = jsonDecode(text.output!) as Map<String, dynamic>;
      // if (!json.containsKey('weeks')) {
      //   throw const FormatException("JSON is null or missing 'weeks' key");
      // }

      List<dynamic> weeks = json['running_plan']['weeks'];
      for (int i = 0; i < weeks.length; i++) {
        debugPrint("weeks.length = ${weeks.length}");
        var week = weeks[i];
        List<dynamic> dailySchedule = week['daily_schedule'];
        if (week == null || (i >= 1 && dailySchedule.length != 7)) {
          // change
          debugPrint(week.length.toString());
          throw FormatException(
              "Week ${i + 1} has less than 7 entries, contains null, or is missing");
        }
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('trainingPlans')
          .add(json);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'activePlan': true});
      return json;
    } on FormatException catch (e) {
      debugPrint("Failed to generate plan $e");
      attempts++;
      if (attempts >= maxAttempts) {
        debugPrint(
            "Failed to generate plan after $attempts attempts, here's a basic plan instead");
        Map<String, dynamic> json = jsonDecode(Constants.GENERALRUNNINGPLAN);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('trainingPlans')
            .add(json);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'activePlan': true});
        return json;
      }
    }
  }
  return null;
}
