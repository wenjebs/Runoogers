import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:runningapp/database/repository.dart';
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
                        doc as DocumentSnapshot<Map<String, dynamic>>,
                        null,
                      );
                      String formattedDate =
                          DateFormat('EEEE \'at\' h:mma').format(
                        DateTime.parse(run.date),
                      );
                      return Card(
                        color: Theme.of(context).colorScheme.secondaryFixed,
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
                                              auth: FirebaseAuth.instance,
                                              repository: Repository(),
                                              photoUrl: doc['imageUrl'] ?? '',
                                              runDistance:
                                                  double.parse(run.distance),
                                              runTime: int.parse(run.time),
                                              runPace: run.pace,
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(formattedDate),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // Distribute space evenly
                                children: [
                                  // Distance
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.directions_run,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ), // Use an appropriate icon
                                      Text(
                                        "${double.parse(run.distance).toStringAsFixed(2)} km",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Time
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ), // Use an appropriate icon
                                      Text(
                                        run.time,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Pace
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.speed,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ), // Use an appropriate icon
                                      Text(
                                        "${run.pace.toStringAsFixed(2)} min/km",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
