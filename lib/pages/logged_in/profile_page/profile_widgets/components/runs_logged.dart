import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/models/run.dart';
import 'package:runningapp/pages/logged_in/profile_page/providers/runs_provider.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_pages/running_post_creation_page.dart';
import 'package:runningapp/state/backend/authenticator.dart';

class RunsSection extends ConsumerWidget {
  final String? userId;
  const RunsSection({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(getRunsProvider(userId ?? Authenticator().userId!));
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(30),
              child: runs.when(
                data: (runs) {
                  return ListView(
                    children: runs.docs.map((doc) {
                      Run run = Run.fromFirestore(
                          doc as DocumentSnapshot<Map<String, dynamic>>, null);
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    doc['name'] ?? 'Unknown',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      icon: const Icon(Icons.share),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RunningPostCreationPage(
                                                    photoUrl:
                                                        doc['imageUrl'] ?? ''),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text("Date: ${run.date}"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Text("Distance"),
                                        Text("${run.distance} km"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Text("Time"),
                                        Text(run.time),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Text("Pace"),
                                        Text(
                                            "${run.pace.toStringAsFixed(2)} min/km"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Image.network(
                                doc['imageUrl'] ?? '',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const SizedBox(
                  width: 100,
                  height: 50,
                  child: Text("Loading runs..."),
                ),
                error: (err, stack) => Text('Error: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
