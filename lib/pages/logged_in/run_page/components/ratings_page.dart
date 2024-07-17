import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_pages/running_post_creation_page.dart';
import 'package:runningapp/pages/logged_in/training_page/dynamic_plan/update_plan_provider.dart';

class RatingPage extends ConsumerWidget {
  final bool updateDifficulty;
  final String downloadUrl;

  const RatingPage(
      {super.key, required this.updateDifficulty, required this.downloadUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('How difficult was it?')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
                icon: CircleAvatar(child: Text('${index + 1}')),
                onPressed: () async {
                  final user = await Repository.getUserProfile(
                      auth.FirebaseAuth.instance.currentUser!.uid);

                  double avgDifficulty = user.averageDifficulty + index + 1.0;

                  final updatedUser =
                      user.copyWith(averageDifficulty: avgDifficulty);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update(updatedUser.toFirestore());

                  if (updateDifficulty) {
                    debugPrint('updating plan');

                    final shouldRegenerate = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Regenerate Plan?'),
                            content: const Text(
                                'Do you want to regenerate your plan based on the new difficulty?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        ) ??
                        false; // Default to false if null

                    if (shouldRegenerate) {
                      await ref.read(updatePlanProvider.future);
                    }
                    avgDifficulty = 0.0;
                  }

                  final updatedNewUser = user.copyWith(averageDifficulty: 0.0);
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .update(updatedNewUser.toFirestore());

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) =>
                          RunningPostCreationPage(photoUrl: downloadUrl)));
                });
          }),
        ),
      ),
    );
  }
}
