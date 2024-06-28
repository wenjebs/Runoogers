import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';

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
                      'caption': _caption,
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'likes': 0,
                      'run': {},
                    });
                    Navigator.pop(context);
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
