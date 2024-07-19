import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
import 'package:runningapp/pages/logged_in/training_page/onboarding/training_onboarding_page.dart';

class TrainingCard extends StatelessWidget {
  final bool trainingOnboarded;
  final Repository repository;
  const TrainingCard(
      {super.key, required this.trainingOnboarded, required this.repository});

  String getFormattedTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM');
    return formatter.format(now);
  }

  Future<String> getTodayTrainingType() async {
    var plans = await repository.getTrainingPlans();
    if (plans.isEmpty) {
      return "No plans";
    } else {
      return await repository.getTodayTrainingType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getTodayTrainingType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == "No plans") {
          return noTrainingPlanCard(context);
        } else {
          return currentDayPlanCard(context, snapshot.data!);
        }
      },
    );
  }

  Widget noTrainingPlanCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQT9LQk2qPdPE0IK_35wLlAkh8-5Xsg-6NaIQ&s'), // Background image
                  fit: BoxFit.cover, // Cover the entire container space
                ),
              ),
              height: MediaQuery.of(context).size.height *
                  0.2, // 20% of screen height
              width: double.infinity, // Take up full width available
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    // Example icon
                    Text(
                      'No training plan found.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.fitness_center, size: 50, color: Colors.black),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Navigate based on trainingOnboarded boolean
                  if (trainingOnboarded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              repository: repository, initialIndex: 5)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TrainingOnboardingPage()),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "Start a training plan",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget currentDayPlanCard(BuildContext context, String planType) {
    IconData icon = Icons.run_circle; // Default icon
    switch (planType) {
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
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn2.hubspot.net/hubfs/2936356/maxresdefault.jpg'), // Background image
                  fit: BoxFit.cover, // Cover the entire container space
                ),
              ),
              height: MediaQuery.of(context).size.height *
                  0.2, // 20% of screen height
              width: double.infinity, // Take up full width available
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Today: $planType',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(icon),
                  ],
                ),
              ),
            ),
            if (planType != 'Rest day')
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // Navigate based on trainingOnboarded boolean
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                repository: repository, initialIndex: 1)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "Go running",
                          style: TextStyle(
                            color:
                                Colors.black, // White color for better contrast
                            fontWeight: FontWeight.bold,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0, 1), // Shadow position
                                blurRadius: 3, // Shadow blur radius
                                color: Color.fromARGB(
                                    150, 0, 0, 0), // Black shadow for depth
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
