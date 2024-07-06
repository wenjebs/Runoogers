import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';
import 'package:runningapp/pages/logged_in/story_page/models/progress_model.dart';
import 'package:runningapp/pages/logged_in/story_page/models/quests_model.dart';
import 'package:runningapp/pages/logged_in/story_page/providers/providers.dart';

class ActiveQuestDisplayPage extends ConsumerWidget {
  final List<Quest> quests;
  final String activeStory;

  const ActiveQuestDisplayPage({
    super.key,
    required this.quests,
    required this.activeStory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questProgress = ref.watch(questProgressProvider(activeStory));
    // debugPrint(questProgress.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Quests"),
      ),
      body: switch (questProgress) {
        AsyncData(:final value) => ListView.builder(
            itemCount: quests.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    startQuest(quests[index], context, value);
                  },
                  child: QuestCardContentWidget(
                      quests: quests, questProgress: value, index: index),
                ),
              );
            },
          ),
        AsyncError(:final error) => Text(error.toString()),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  void startQuest(
    Quest quest,
    BuildContext context,
    QuestProgressModel? questProgress,
  ) {
    // Go run page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunPage(
          title: quest.getTitle,
          storyRun: true,
          activeStory: activeStory,
          questProgress: questProgress,
        ),
      ),
    );
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
