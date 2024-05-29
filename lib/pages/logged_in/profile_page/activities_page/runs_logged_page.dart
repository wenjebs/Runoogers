import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/runs_provider.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class RunsLoggedPage extends ConsumerWidget {
  const RunsLoggedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(getRunsProvider(Authenticator().userId!));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged Runs'),
      ),
      body: runs.when(
        data: (runs) {
          return ListView(
            children: runs.docs.map((doc) {
              return ListTile(
                title: Text(doc['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${doc['distance']} km"),
                    Text("Time Taken: ${doc['time']}"),
                    Text("Date: ${doc['date']}"),
                  ],
                ),
              );
            }).toList(),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}
