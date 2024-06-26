import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:runningapp/pages/logged_in/training_page/plan_generator.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool generated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  generated = true;
                });
              },
              color: Theme.of(context).colorScheme.primary,
              child: const Text('Generate'),
            ),
            generated
                ? Consumer(builder: (context, ref, child) {
                    final AsyncValue<Map<String, dynamic>> jsonPlan =
                        ref.watch(planProvider);
                    debugPrint(jsonPlan.value.toString());

                    if (jsonPlan is AsyncLoading) {
                      return Lottie.asset('lib/assets/lottie/ai.json');
                    } else if (jsonPlan is AsyncError) {
                      return Text(jsonPlan.error.toString(),
                          style: TextStyle(color: Colors.red, fontSize: 16));
                    } else if (jsonPlan is AsyncData) {
                      List<dynamic> runningPlan =
                          jsonPlan.value!['running_plan']['weeks'];
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: runningPlan.map<Widget>((week) {
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.all(8),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Week ${week['week_number']}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 8),
                                      Text(
                                          'Total distance: ${week['total_distance_km']} km',
                                          style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 4),
                                      Text(
                                          'Running days: ${week['running_days']}',
                                          style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: week['daily_schedule']
                                            .map<Widget>((day) {
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Day of the week: ${day['day_of_week']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Text(
                                                    'Distance: ${day['distance_km']} km',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text('Type: ${day['type']}',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(); // Fallback for unexpected state
                    }
                  })
                : const Text("Not generated"),
            MaterialButton(
              onPressed: () {
                setState(() {
                  generated = false;
                });
              },
              color: Theme.of(context).colorScheme.primary,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
