import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/training_page/plan_generator.dart';
import 'package:runningapp/pages/logged_in/training_page/training_schedule.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool generated = false;
  late List<dynamic> runningPlan = [];

  Future<void> _fetchTrainingPlans() async {
    final plans = await Repository.getTrainingPlans();
    setState(() {
      runningPlan = plans;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTrainingPlans();
    // debugPrint(runningPlan.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (runningPlan.isNotEmpty) {
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
                child: const Text('Regenerate'),
              ),
              TrainingSchedule(runningPlan: runningPlan),
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
    } else {
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
                      // debugPrint(jsonPlan.value.toString());

                      if (jsonPlan is AsyncLoading) {
                        return Lottie.asset('lib/assets/lottie/ai.json');
                      } else if (jsonPlan is AsyncError) {
                        return Text(jsonPlan.error.toString(),
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16));
                      } else if (jsonPlan is AsyncData) {
                        List<dynamic> runningPlan =
                            jsonPlan.value!['running_plan']['weeks'];
                        return TrainingSchedule(runningPlan: runningPlan);
                      } else {
                        return const SizedBox(); // Fallback for unexpected state
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
}
