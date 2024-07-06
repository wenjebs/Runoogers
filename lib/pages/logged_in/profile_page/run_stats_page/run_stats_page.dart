import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';

class RunStatsPage extends ConsumerWidget {
  const RunStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use userInfoProvider to get user information
    final userInfoAsyncValue = ref.watch(userInformationProvider);

    return Scaffold(
      body: userInfoAsyncValue.when(
        data: (snapshot) {
          // Assuming 'posts' and 'friends' are fields in your user document
          // final postsCount = snapshot.docs.length; // Number of posts
          if (snapshot != null) {
            final fastestTime = snapshot['fastestTime'] ?? 0;
            final totalTime = snapshot['totalTime'] ?? 0;
            final longestDistance = snapshot['longestDistance'] ?? 0;
            final totalRuns = snapshot['totalRuns'] ?? 0;
            final totalDistance = snapshot['totalDistance'] ?? 0;
            final totalDistanceRan = snapshot['totalDistanceRan'] ?? 0;
            final points = snapshot['points'] ?? 0;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fastest Time: $fastestTime'),
                  Text('Total Time: $totalTime'),
                  Text('Longest Distance: $longestDistance'),
                  Text('Total Runs: $totalRuns'),
                  Text('Total Distance: $totalDistance'),
                  Text('Total Distance Ran: $totalDistanceRan'),
                  Text('Points: $points'),
                  // Add more stats as needed
                ],
              ),
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
