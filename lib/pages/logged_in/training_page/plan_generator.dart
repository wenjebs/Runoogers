import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runningapp/pages/logged_in/training_page/prompt.dart';

part 'plan_generator.g.dart';

final gemini = Gemini.instance;

// Generate a plan from the model and return as json
@riverpod
Future<Map<String, dynamic>> plan(PlanRef ref) async {
  // Get the text from the model
  final text =
      await gemini.text(Prompt().prompt, modelName: 'models/gemini-pro');

  // Encode it into a json
  final json = jsonDecode(text!.output!) as Map<String, dynamic>;

  return json;
}
