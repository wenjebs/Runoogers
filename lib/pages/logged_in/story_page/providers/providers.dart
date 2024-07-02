// Quest progress provider
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/story_page/models/progress_model.dart';

part 'providers.g.dart';

@riverpod
Future<QuestProgressModel> questProgress(
  QuestProgressRef ref,
  String storyId,
) async {
  final output = await Repository.getQuestProgress(storyId);
  debugPrint(output.toString());
  return output;
}
