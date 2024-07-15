import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';
import 'package:runningapp/models/progress_model.dart';
import 'package:runningapp/models/quests_model.dart';
import 'package:runningapp/pages/logged_in/story_page/providers/providers.dart';

class ActiveQuestDisplayPage extends ConsumerWidget {
  final List<Quest> quests;
  final String activeStoryTitle;

  const ActiveQuestDisplayPage({
    super.key,
    required this.quests,
    required this.activeStoryTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questProgress = ref.watch(questProgressProvider(activeStoryTitle));
    // debugPrint(questProgress.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Quests"),
      ),
      body: switch (questProgress) {
        AsyncData(:final value) => RefreshIndicator(
            onRefresh: () {
              // ignore: unused_result
              ref.refresh(questProgressProvider(activeStoryTitle));
              return Future.value();
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: quests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            if (index != 0 &&
                                value.getQuestCompletionStatus[index - 1] ==
                                    false) {
                              showSnackBarMessage(
                                  context, "Complete previous quest first!");
                            } else if (value.getQuestCompletionStatus[index] ==
                                false) {
                              startQuest(
                                  quests[index], context, value, ref, index);
                            } else {
                              showSnackBarMessage(
                                  context, "Quest already completed!");
                            }
                          },
                          child: QuestCardContentWidget(
                              quests: quests,
                              questProgress: value,
                              index: index),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool confirm = await showConfirmationDialog(context);
                    if (confirm) {
                      await Repository.resetQuestsProgress(activeStoryTitle);
                      // ignore: unused_result
                      ref.refresh(questProgressProvider(activeStoryTitle));
                    }
                  },
                  child: const Text("Reset quests progress"),
                ),
              ],
            ),
          ),
        AsyncError(:final error) => Text(error.toString()),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Future<bool> showConfirmationDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to reset?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false; // Returning false if dialog is dismissed
  }

  void showSnackBarMessage(BuildContext context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 10,
            right: 10),
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> startQuest(
    Quest quest,
    BuildContext context,
    QuestProgressModel? questProgress,
    WidgetRef ref,
    int currentQuest,
  ) async {
    // Go run page
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunPage(
          title: quest.getTitle,
          storyRun: true,
          activeStoryTitle: activeStoryTitle,
          questProgress: questProgress,
          questDistance: quest.getDistance,
          currentQuest: currentQuest,
        ),
      ),
    );
    // ignore: unused_result
    ref.refresh(questProgressProvider(activeStoryTitle));
  }
}

class QuestCardContentWidget extends StatelessWidget {
  const QuestCardContentWidget({
    super.key,
    required this.quests,
    required this.questProgress,
    required this.index,
  });

  final List<Quest> quests;
  final QuestProgressModel? questProgress;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            quests[index].getTitle,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0),
          questProgress == null
              ? const Text("Loading...")
              : Text(
                  questProgress!.getQuestCompletionStatus[index]
                      ? "Completed"
                      : "Not completed",
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
          const SizedBox(height: 5.0),
          questProgress == null
              ? const LinearProgressIndicator()
              : Text(
                  "${(questProgress!.getQuestDistanceProgress[index]).toStringAsFixed(1)} / ${quests[index].getDistance} km"),
          const SizedBox(height: 5.0),
          questProgress == null
              ? const LinearProgressIndicator()
              : LinearProgressIndicator(
                  backgroundColor: Colors.red,
                  color: Colors.green,
                  value: questProgress!.getQuestDistanceProgress[index] /
                      quests[index].getDistance,
                ),
          const SizedBox(height: 5.0),
          Text(
            quests[index].getDescription,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
