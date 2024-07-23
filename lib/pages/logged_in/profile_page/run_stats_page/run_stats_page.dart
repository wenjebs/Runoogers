import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';

class RunStatsPage extends ConsumerWidget {
  const RunStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInformationProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(240),
      body: userInfoAsyncValue.when(
        data: (snapshot) {
          if (snapshot != null) {
            final fastestTime = snapshot['fastestTime'] ?? 0;
            final totalTime = snapshot['totalTime'] ?? 0;
            final longestDistance = snapshot['longestDistance'] ?? 0;
            final totalRuns = snapshot['totalRuns'] ?? 0;
            final totalDistance = snapshot['totalDistance'] ?? 0;
            final totalDistanceRan = snapshot['totalDistanceRan'] ?? 0;
            final points = snapshot['points'] ?? 0;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatCard(
                        title: 'Fastest Time',
                        value: '$fastestTime',
                        icon: Icons.timer),
                    StatCard(
                        title: 'Total Time',
                        value: '$totalTime',
                        icon: Icons.hourglass_bottom),
                    StatCard(
                        title: 'Longest Distance',
                        value: '$longestDistance',
                        icon: Icons.route),
                    StatCard(
                        title: 'Total Runs',
                        value: '$totalRuns',
                        icon: Icons.directions_run),
                    StatCard(
                        title: 'Total Distance',
                        value: '$totalDistance',
                        icon: Icons.map),
                    StatCard(
                        title: 'Total Distance Ran',
                        value: '$totalDistanceRan',
                        icon: Icons.terrain),
                    StatCard(
                        title: 'Points', value: '$points', icon: Icons.star),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            key: const Key("StatsError"),
            'Error: $error',
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.white, // Apple widgets often use a white or light background
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Subtle shadow
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black, // High contrast for readability
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .primaryColor, // Use the primary color for emphasis
            ),
          ),
        ],
      ),
    );
  }
}
