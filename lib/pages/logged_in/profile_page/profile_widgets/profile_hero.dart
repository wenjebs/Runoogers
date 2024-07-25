import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class ProfileHero extends StatefulWidget {
  final String avatarUrl;
  const ProfileHero({super.key, required this.avatarUrl});

  @override
  State<ProfileHero> createState() => _ProfileHeroState();
}

class _ProfileHeroState extends State<ProfileHero> {
  String currentView = 'left';

  Future<String> fetchProfilePicUrl() async {
    try {
      // Fetch the user document from Firestore using the userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        // Assuming 'profilePicUrl' is the field name in the document
        return userDoc['profilePic'] ??
            'https://example.com/default-profile-pic.jpg'; // Provide a default URL in case the field is missing
      } else {
        // Handle the case where the user document does not exist
        return 'https://example.com/default-profile-pic.jpg'; // Default URL or error handling
      }
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print(e); // Consider logging the error or handling it appropriately
      return 'https://example.com/default-profile-pic.jpg'; // Return a default URL in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentView == 'right')
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(() {
                        currentView = 'left';
                      });
                    },
                  ),
                ),
              SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: currentView == 'right'
                      ? O3D(
                          src: widget.avatarUrl,
                          autoRotate: true,
                        )
                      : FutureBuilder<String>(
                          future: fetchProfilePicUrl(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            } else {
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                ),
              ),
              if (currentView == 'left')
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        currentView = 'right';
                      });
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
