import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';

final trainingOnboardingProvider =
    StateNotifierProvider<TrainingOnboardingNotifier, TrainingOnboardingState>(
        (ref) {
  return TrainingOnboardingNotifier();
});

class TrainingOnboardingState {
  final int timesPerWeek;
  final double targetDistance;
  final String targetTime;
  final int weeksToTrain;
  final String level;

  TrainingOnboardingState(
      {this.timesPerWeek = 0,
      this.targetDistance = 0,
      this.targetTime = '',
      this.weeksToTrain = 0,
      this.level = ""});
}

class TrainingOnboardingNotifier
    extends StateNotifier<TrainingOnboardingState> {
  TrainingOnboardingNotifier() : super(TrainingOnboardingState());

  void updateTimesPerWeek(int timesPerWeek) {
    state = TrainingOnboardingState(
      timesPerWeek: timesPerWeek,
      targetDistance: state.targetDistance,
      targetTime: state.targetTime,
      weeksToTrain: state.weeksToTrain,
      level: state.level,
    );
  }

  void updateTargetDistance(double targetDistance) {
    state = TrainingOnboardingState(
      timesPerWeek: state.timesPerWeek,
      targetDistance: targetDistance,
      targetTime: state.targetTime,
      weeksToTrain: state.weeksToTrain,
      level: state.level,
    );
  }

  void updateTargetTime(String targetTime) {
    state = TrainingOnboardingState(
      timesPerWeek: state.timesPerWeek,
      targetDistance: state.targetDistance,
      targetTime: targetTime,
      weeksToTrain: state.weeksToTrain,
      level: state.level,
    );
  }

  void updateWeeksToTrain(int weeksToTrain) {
    state = TrainingOnboardingState(
        timesPerWeek: state.timesPerWeek,
        targetDistance: state.targetDistance,
        targetTime: state.targetTime,
        weeksToTrain: weeksToTrain,
        level: state.level);
  }

  void updateLevel(String level) {
    state = TrainingOnboardingState(
        timesPerWeek: state.timesPerWeek,
        targetDistance: state.targetDistance,
        targetTime: state.targetTime,
        weeksToTrain: state.weeksToTrain,
        level: level);
  }

  Future<void> saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'timesPerWeek': state.timesPerWeek,
      'targetDistance': state.targetDistance,
      'targetTime': state.targetTime,
      'weeksToTrain': state.weeksToTrain,
    }, SetOptions(merge: true));
  }
}

class TrainingOnboardingPage extends ConsumerStatefulWidget {
  const TrainingOnboardingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrainingOnboardingPageState();
}

class _TrainingOnboardingPageState
    extends ConsumerState<TrainingOnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More information about your training plan"),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingStep(
            title: "Select your training level",
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: "Choose your level",
                labelText: "Training Level",
              ),
              items: const [
                DropdownMenuItem(value: "beginner", child: Text("Beginner")),
                DropdownMenuItem(
                    value: "intermediate", child: Text("Intermediate")),
                DropdownMenuItem(value: "advanced", child: Text("Advanced")),
              ],
              onChanged: (value) {
                ref
                    .read(trainingOnboardingProvider.notifier)
                    .updateLevel(value!);
              },
            ),
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          OnboardingStep(
            title: "How many times per week can you run?",
            child: TextField(
              decoration: const InputDecoration(hintText: "Times per week"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                final intValue = int.tryParse(value);
                if (intValue != null) {
                  // Use intValue here
                  ref
                      .read(trainingOnboardingProvider.notifier)
                      .updateTimesPerWeek(intValue);
                } else {
                  // Handle the case where the conversion fails (e.g., input is not a valid integer)
                }
              },
            ),
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          OnboardingStep(
            title: "How many weeks do you have to train?",
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                hintText: "Select weeks",
                labelText: "Weeks to train",
              ),
              items: <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  ref
                      .read(trainingOnboardingProvider.notifier)
                      .updateWeeksToTrain(newValue);
                }
              },
            ),
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          OnboardingStep(
            title: "What's the target distance you want to achieve?",
            child: TextField(
              decoration:
                  const InputDecoration(hintText: "Target distance (km)"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onChanged: (value) {
                final doubleValue = double.tryParse(value);
                if (doubleValue != null) {
                  // Use doubleValue here
                  ref
                      .read(trainingOnboardingProvider.notifier)
                      .updateTargetDistance(doubleValue);
                } else {
                  // Handle the case where the conversion fails (e.g., input is not a valid double)
                }
              },
            ),
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          OnboardingStep(
            title: "Target time per kilometre?",
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: "Select target time",
                labelText: "Target time (min:sec)",
              ),
              items: <String>[
                "4:00",
                "4:15",
                "4:30",
                "4:45",
                "5:00",
                "5:15",
                "5:30",
                "5:45",
                "6:00",
                "6:15",
                "6:30",
                "6:45",
                "7:00",
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  ref
                      .read(trainingOnboardingProvider.notifier)
                      .updateTargetTime(newValue);
                }
              },
            ),
            onNext: () async {
              await ref
                  .read(trainingOnboardingProvider.notifier)
                  .saveToFirestore();

              // Get the current user's ID
              final userId = FirebaseAuth.instance.currentUser!.uid;

              // Update the 'onboarded' field in Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({'trainingOnboarded': true});

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage(
                          initialIndex: 5,
                        )),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingStep extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onNext;

  const OnboardingStep({
    super.key,
    required this.title,
    required this.child,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24.0),
          ),
          child,
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onNext,
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
