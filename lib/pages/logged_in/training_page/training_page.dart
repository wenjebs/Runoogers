import 'dart:convert';

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
                ? Consumer(
                    builder: (context, ref, child) {
                      final AsyncValue<Map<String, dynamic>> jsonPlan =
                          ref.watch(planProvider);
                      debugPrint(jsonPlan.value.toString());

                      if (jsonPlan is AsyncLoading) {
                        return Lottie.asset('lib/assets/lottie/ai.json');
                      } else if (jsonPlan is AsyncError) {
                        Text(jsonPlan.error.toString());
                      } else if (jsonPlan is AsyncData) {
                        List<dynamic> runningPlan =
                            jsonPlan.value!['running_plan']['weeks'];
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: runningPlan.map<Widget>((week) {
                                return Column(
                                  children: [
                                    Text('Week ${week['week_number']}'),
                                    Text(
                                        'Total distance: ${week['total_distance_km']}'),
                                    Text(
                                        'Running days: ${week['running_days']}'),
                                    Column(
                                      children: week['daily_schedule']
                                          .map<Widget>((day) {
                                        return Column(
                                          children: [
                                            Text(
                                                'Day of the week: ${day['day_of_week']}'),
                                            Text(
                                                'Distance: ${day['distance_km']}'),
                                            Text('Type: ${day['type']}'),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                      return const Text("Gay");
                    },
                  )
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
