import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
import 'package:runningapp/pages/logged_in/home_page/user_page.dart';

class PostCreationPage extends StatefulWidget {
  const PostCreationPage({super.key});

  @override
  PostCreationPageState createState() => PostCreationPageState();
}

class PostCreationPageState extends State<PostCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _caption = '';

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
                      'timestamp': FieldValue.serverTimestamp(),
                      'caption': _caption,
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'likes': 0,
                      'photoUrl':
                          'https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8189.jpg',
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
