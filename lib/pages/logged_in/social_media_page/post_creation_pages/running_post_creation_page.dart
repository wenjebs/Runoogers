import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';

class RunningPostCreationPage extends StatefulWidget {
  final String photoUrl;
  final double runDistance;
  final int runTime;
  final double runPace;
  final Repository repository;
  final FirebaseAuth auth;
  const RunningPostCreationPage(
      {super.key,
      required this.photoUrl,
      required this.runDistance,
      required this.runTime,
      required this.runPace,
      required this.repository,
      required this.auth});

  @override
  RunningPostCreationPageState createState() => RunningPostCreationPageState();
}

class RunningPostCreationPageState extends State<RunningPostCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _caption = '';
  String get photoUrl => widget.photoUrl;

  String _formatTime(int milliseconds) {
    int seconds = milliseconds ~/ 1000;
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Distribute space evenly
                children: [
                  // Distance
                  Column(
                    children: [
                      Icon(
                        Icons.directions_run,
                        color: Theme.of(context).colorScheme.primary,
                      ), // Use an appropriate icon
                      Text(
                        "${widget.runDistance.toStringAsFixed(2)} km",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Time
                  Column(
                    children: [
                      Icon(
                        Icons.timer,
                        color: Theme.of(context).colorScheme.primary,
                      ), // Use an appropriate icon
                      Text(
                        _formatTime(widget.runTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Pace
                  Column(
                    children: [
                      Icon(
                        Icons.speed,
                        color: Theme.of(context).colorScheme.primary,
                      ), // Use an appropriate icon
                      Text(
                        "${widget.runPace.toStringAsFixed(2)} min/km",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Image.network(
                photoUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Caption'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a caption';
                  }
                  return null;
                },
                onSaved: (value) {
                  _caption = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.repository.addPost('posts', {
                      'timestamp': FieldValue.serverTimestamp(),
                      'caption': _caption,
                      'userId': widget.auth.currentUser!.uid,
                      'likes': 0,
                      'runImageUrl': photoUrl,
                      'runDistance': widget.runDistance,
                      'runDuration': widget.runTime,
                      'runPace': widget.runPace,
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          initialIndex: 0,
                          repository: widget.repository,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
