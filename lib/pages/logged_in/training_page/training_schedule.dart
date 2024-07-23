import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';

class TrainingSchedule extends StatelessWidget {
  final List<dynamic> runningPlan;
  const TrainingSchedule({super.key, required this.runningPlan});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: runningPlan.map<Widget>((week) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week ${week['week_number']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total distance: ${week['total_distance_km']} km',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //     'Running days: ${week['running_days']}',
                    //     style: const TextStyle(fontSize: 16)),
                    // const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: week['daily_schedule'].map<Widget>((day) {
                        IconData icon = Icons.run_circle; // Default icon
                        switch (day['type']) {
                          case 'Easy run':
                            icon = Icons.directions_run;
                            break;
                          case 'Speed work':
                            icon = Icons.flash_on;
                            break;
                          case 'Long run':
                            icon = Icons.route;
                            break;
                          case 'Rest day':
                            icon = Icons.hotel;
                            break;
                          case 'Recovery run':
                            icon = Icons.healing;
                            break;
                          case 'Interval training':
                            icon = Icons.timer;
                            break;
                        }
                        return Card(
                          elevation: 2,
                          color: Theme.of(context).colorScheme.surface,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(icon),
                            title: Text('${day['day_of_week']}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${day['distance_km']} km',
                                    style: const TextStyle(fontSize: 16)),
                                Text('${day['type']}',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            trailing: day['type'] != 'Rest day'
                                ? IconButton(
                                    icon: const Icon(Icons.directions_run),
                                    onPressed: () {
                                      // Navigate to the runs page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(
                                              repository: Repository(),
                                              initialIndex: 1),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
