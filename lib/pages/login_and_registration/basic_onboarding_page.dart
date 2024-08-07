import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/avatar_onboarding.dart';

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
  const OnboardingPage({super.key, required this.auth});
  final FirebaseAuth auth;

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  bool _isNameValid = false;
  bool _isAgeValid = false;

  void _validateName(String value) {
    setState(() {
      _isNameValid = value.trim().isNotEmpty;
    });
  }

  void _validateAge(String value) {
    setState(() {
      _isAgeValid = value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) > 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

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
            onNext: () async {
              await _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              FocusScope.of(context).requestFocus(_usernameFocusNode);
            },
            isInputValid: _isNameValid,
            child: TextField(
              focusNode: _nameFocusNode,
              decoration: const InputDecoration(hintText: "Enter your name"),
              onChanged: (value) {
                ref.read(onboardingProvider.notifier).updateName(value);
                _validateName(value);
              },
            ),
          ),
          OnboardingStep(
            isInputValid: true,
            title: "Choose a username",
            child: TextField(
              focusNode: _usernameFocusNode,
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

              if (!usernameExists && username.isNotEmpty) {
                // Username is unique, allow the user to proceed
                await _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
                FocusScope.of(context).requestFocus(_ageFocusNode);
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
            isInputValid: _isAgeValid,
            title: "What's your age?",
            child: TextField(
                focusNode: _ageFocusNode,
                decoration: const InputDecoration(hintText: "Enter your age"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref.read(onboardingProvider.notifier).updateAge(value);
                  _validateAge(value);
                }),
            onNext: () async {
              await ref.read(onboardingProvider.notifier).saveToFirestore();

              // Get the current user's ID
              final userId = widget.auth.currentUser!.uid;

              // Update the 'onboarded' field in Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({'onboarded': true});

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AvatarOnboarding(
                        auth: FirebaseAuth.instance,
                        storage: FirebaseStorage.instance,
                        firestore: FirebaseFirestore.instance)),
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
  final bool isInputValid;

  const OnboardingStep({
    super.key,
    required this.title,
    required this.child,
    required this.onNext,
    this.isInputValid = false,
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
            onPressed: isInputValid ? onNext : null,
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
