import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/story_page/models/quests_model.dart';

class ActiveQuestDisplayPage extends ConsumerWidget {
  final List<Quest> quests;
  const ActiveQuestDisplayPage({
    super.key,
    required this.quests,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInformationProvider).asData?.value;
    debugPrint(userInfo.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Quests"),
      ),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(quests[index].getTitle),
            subtitle: Text(quests[index].getDescription),
          );
        },
      ),
    );
  }
}
