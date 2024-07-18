import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key});

  Future<String> fetchAvatarUrl(String userId) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userDoc.get();
    if (userSnapshot.exists) {
      return userSnapshot.get('avatarUrl');
    } else {
      return 'Default URL or Error Handling';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            // BACKGROUND IMAGE CONTAINER
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.cover,
              //     image: NetworkImage(
              //       'https://images.unsplash.com/photo-1434394354979-a235cd36269d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fG1vdW50YWluc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
              //     ), // To BE CHANGED FROM DATABASE
              //   ),
              // ),
            ),
            Center(
              child: FutureBuilder<String>(
                future: fetchAvatarUrl(FirebaseAuth.instance.currentUser!
                    .uid), // Replace 'userId' with the actual user ID
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                        color: Colors
                            .white); // Show loading indicator while waiting
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Use the fetched URL
                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: O3D(
                        src: snapshot.data!,
                        disableZoom: false,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
