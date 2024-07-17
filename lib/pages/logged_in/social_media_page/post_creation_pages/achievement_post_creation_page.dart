import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/achievements_page/achievement.dart';

class AchievementPostCreationPage extends StatefulWidget {
  final String picture;
  final String name;
  final String description;
  final int points;

  const AchievementPostCreationPage(
      {super.key,
      required this.picture,
      required this.name,
      required this.description,
      required this.points});

  @override
  AchievementPostCreationPageState createState() =>
      AchievementPostCreationPageState();
}

class AchievementPostCreationPageState
    extends State<AchievementPostCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _caption = '';
  String get picture => widget.picture;
  String get name => widget.name;
  String get description => widget.description;
  int get points => widget.points;

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
              Achievement(
                  picture: picture,
                  name: name,
                  description: description,
                  points: points),
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
                    Repository.addPost('posts', {
                      'caption': _caption,
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'likes': 0,
                      'timestamp': FieldValue.serverTimestamp(),
                      'achievementDescription': description,
                      'achievementTitle': name,
                      'achievementImageUrl': picture,
                      'achievementPoints': points,
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage(initialIndex: 0)));
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
