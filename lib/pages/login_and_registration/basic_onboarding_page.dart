import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runningapp/pages/logged_in/home_page.dart';

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);

class OnboardingState {
  final String name;
  final String age;
  final String username;

  OnboardingState({
    this.name = '',
    this.age = '',
    this.username = '',
  });
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  void updateName(String name) {
    state =
        OnboardingState(name: name, age: state.age, username: state.username);
  }

  void updateAge(String age) {
    state =
        OnboardingState(name: state.name, age: age, username: state.username);
  }

  void updateUsername(String username) {
    state =
        OnboardingState(name: state.name, age: state.age, username: username);
  }

  Future<void> saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'name': state.name,
      'age': state.age,
      'username': state.username,
    }, SetOptions(merge: true));
  }
}

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingStep(
            title: "What's your name?",
            child: TextField(
              decoration: const InputDecoration(hintText: "Enter your name"),
              onChanged: (value) =>
                  ref.read(onboardingProvider.notifier).updateName(value),
            ),
            onNext: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          OnboardingStep(
            title: "Choose a username",
            child: TextField(
              decoration:
                  const InputDecoration(hintText: "Enter your username"),
              onChanged: (value) =>
                  ref.read(onboardingProvider.notifier).updateUsername(value),
            ),
            onNext: () async {
              final username = ref.read(onboardingProvider).username;

              // Check if the username is unique in Firestore
              final usernameExists = await FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isEqualTo: username)
                  .get()
                  .then((snapshot) => snapshot.docs.isNotEmpty);

              if (!usernameExists) {
                // Username is unique, allow the user to proceed
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                // Show an error message if the username is taken
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Username is already taken, please choose another one.')),
                );
              }
            },
          ),
          OnboardingStep(
            title: "What's your age?",
            child: TextField(
              decoration: const InputDecoration(hintText: "Enter your age"),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  ref.read(onboardingProvider.notifier).updateAge(value),
            ),
            onNext: () async {
              await ref.read(onboardingProvider.notifier).saveToFirestore();

              // Get the current user's ID
              final userId = FirebaseAuth.instance.currentUser!.uid;

              // Update the 'onboarded' field in Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({'onboarded': true});

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
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
