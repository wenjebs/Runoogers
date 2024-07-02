import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final questProgress =
        ref.watch(questProgressProvider(activeStory)).asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Quests"),
      ),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${quests[index].getTitle} - ${quests[index].getDistance} km",
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  questProgress == null
                      ? const Text("Loading...")
                      : Text(
                          questProgress.getQuestCompletionStatus[index]
                              ? "Completed"
                              : "Not completed",
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(height: 5.0),
                  questProgress == null
                      ? const LinearProgressIndicator()
                      : LinearProgressIndicator(
                          backgroundColor: Colors.red,
                          color: Colors.green,
                          value: questProgress.getQuestDistanceProgress[index] /
                              quests[index].getDistance,
                        ),
                  const SizedBox(height: 5.0),
                  Text(
                    quests[index].getDescription,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
