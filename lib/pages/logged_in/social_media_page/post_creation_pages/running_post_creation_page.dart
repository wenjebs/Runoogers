import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';

class RunningPostCreationPage extends StatefulWidget {
  final String photoUrl;
  final Repository repository;
  final FirebaseAuth auth;
  const RunningPostCreationPage(
      {super.key,
      required this.photoUrl,
      required this.repository,
      required this.auth});

  @override
  RunningPostCreationPageState createState() => RunningPostCreationPageState();
}

class RunningPostCreationPageState extends State<RunningPostCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _caption = '';
  String get photoUrl => widget.photoUrl;

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
