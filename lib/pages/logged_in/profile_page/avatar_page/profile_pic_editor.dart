import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePicEditor extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  const ProfilePicEditor({
    super.key,
    required this.auth,
    required this.storage,
    required this.firestore,
  });

  @override
  _ProfilePicEditorState createState() => _ProfilePicEditorState();
}

class _ProfilePicEditorState extends State<ProfilePicEditor> {
  String? selectedMood = 'happy';
  String? selectedPose = 'power-stance';
  String imageUrl = '';
  String avatarId = '';
  String currentMood = 'happy';
  String currentPose = 'power-stance';

  @override
  void initState() {
    super.initState();
    fetchUserAvatarId();
    fetchUserProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Picture'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Select Mood',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.sentiment_very_satisfied,
                      color: currentMood == 'lol'
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary),
                  onPressed: () => setState(() {
                    updateMood('lol');
                    currentMood = 'lol';
                  }),
                  tooltip: 'LOL',
                ),
                IconButton(
                  icon: Icon(Icons.sentiment_dissatisfied,
                      color: currentMood == 'sad'
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary),
                  onPressed: () => setState(() {
                    updateMood('sad');
                    currentMood = 'sad';
                  }),
                  tooltip: 'Sad',
                ),
                IconButton(
                  icon: Icon(Icons.sentiment_dissatisfied,
                      color: currentMood == 'scared'
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary),
                  onPressed: () => setState(() {
                    updateMood('scared');
                    currentMood = 'scared';
                  }),
                  tooltip: 'Scared',
                ),
                IconButton(
                  icon: Icon(Icons.sentiment_very_dissatisfied,
                      color: currentMood == 'rage'
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onPrimary),
                  onPressed: () => setState(() {
                    updateMood('rage');
                    currentMood = 'rage';
                  }),
                  tooltip: 'Rage',
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Select Pose',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tooltip(
                  message: 'Power Stance',
                  child: IconButton(
                      icon: Icon(Icons.accessibility_new,
                          color: currentPose == 'power-stance'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onPrimary),
                      onPressed: () => setState(() {
                            updatePose('power-stance');
                            currentPose = 'power-stance';
                          })),
                ),
                Tooltip(
                  message: 'Relaxed',
                  child: IconButton(
                      icon: Icon(Icons.airline_seat_recline_normal,
                          color: currentPose == 'relaxed'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onPrimary),
                      onPressed: () => setState(() {
                            updatePose('relaxed');
                            currentPose = 'relaxed';
                          })),
                ),
                Tooltip(
                  message: 'Thumbs Up',
                  child: IconButton(
                      icon: Icon(Icons.thumb_up,
                          color: currentPose == 'thumbs-up'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onPrimary),
                      onPressed: () => setState(() {
                            updatePose('thumbs-up');
                            currentPose = 'thumbs-up';
                          })),
                ),
              ],
            ),
            imageUrl.isNotEmpty ? Image.network(imageUrl) : Container(),
            ElevatedButton(
              onPressed: () => saveImageToFirestore(),
              child: const Text('Save Picture'),
            ),
          ],
        ),
      ),
    );
  }

  void updateMood(String mood) {
    setState(() {
      selectedMood = mood;
      fetchImage();
    });
  }

  void updatePose(String pose) {
    setState(() {
      selectedPose = pose;
      fetchImage();
    });
  }

  Future<void> fetchImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      final response = await http.get(Uri.parse(
          'https://models.readyplayer.me/$avatarId.png?expression=$selectedMood&pose=$selectedPose'));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/avatar.png');

        if (!(await directory.exists())) {
          await directory.create(recursive: true);
        }

        if (await file.exists()) {
          await file.delete();
        }

        await file.writeAsBytes(response.bodyBytes);

        String userId = widget.auth.currentUser!.uid;

        try {
          TaskSnapshot snapshot =
              await widget.storage.ref('userAvatars/$userId.png').putFile(file);
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            imageUrl = downloadUrl;
          });
        } catch (e) {
          debugPrint('Error uploading file: $e');
        }
      } else {
        throw Exception('Failed to load avatar');
      }
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> saveImageToFirestore() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/avatar.png');
    String userId = widget.auth.currentUser!.uid;

    try {
      TaskSnapshot snapshot =
          await widget.storage.ref('userAvatars/$userId.png').putFile(file);
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      await widget.firestore
          .collection('users')
          .doc(userId)
          .update({'profilePic': downloadUrl});
      setState(() {
        imageUrl = downloadUrl;
      });
    } catch (e) {
      debugPrint('Error uploading file: $e');
    }
  }

  Future<void> fetchUserAvatarId() async {
    final user = widget.auth.currentUser;
    if (user != null) {
      try {
        final docSnapshot =
            await widget.firestore.collection('users').doc(user.uid).get();
        final tempavatarId = docSnapshot.data()?['avatarId'];
        if (tempavatarId != null) {
          setState(() {
            avatarId = tempavatarId;
          });
        } else {
          debugPrint('No avatarId found for the user');
        }
      } catch (e) {
        debugPrint('Error fetching user document: $e');
      }
    } else {
      debugPrint('No user logged in');
    }
  }

  Future<void> fetchUserProfilePic() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.auth.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        final profilePic = userDoc.data()?['profilePic'];
        if (profilePic != null) {
          setState(() {
            imageUrl = profilePic;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching user profile pic: $e');
    }
  }
}
