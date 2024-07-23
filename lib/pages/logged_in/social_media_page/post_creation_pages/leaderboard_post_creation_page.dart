import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';

class LeaderboardPostCreationPage extends StatefulWidget {
  final int leaderboardPoints;
  final int leaderboardRank;
  final String username;
  final Repository repository;
  const LeaderboardPostCreationPage(
      {super.key,
      required this.leaderboardPoints,
      required this.leaderboardRank,
      required this.username,
      required this.repository});

  @override
  AchievementPostCreationPageState createState() =>
      AchievementPostCreationPageState();
}

class AchievementPostCreationPageState
    extends State<LeaderboardPostCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _caption = '';
  int get leaderboardRank => widget.leaderboardRank;
  int get leaderboardPoints => widget.leaderboardPoints;
  String get username => widget.username;

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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://img.freepik.com/free-vector/colorful-confetti-background-with-text-space_1017-32374.jpg',
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$username is rank #$leaderboardRank globally!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'with $leaderboardPoints points',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
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
                      'caption': _caption,
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'likes': 0,
                      'timestamp': FieldValue.serverTimestamp(),
                      'rank': leaderboardRank,
                      'points': leaderboardPoints,
                      'username': username,
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                repository: widget.repository,
                                initialIndex: 0)));
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
