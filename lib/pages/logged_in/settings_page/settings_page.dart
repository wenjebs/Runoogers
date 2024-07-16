import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/providers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkmode = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  String _newName = '';
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User userProfile = await Repository.getUserProfile(
        auth.FirebaseAuth.instance.currentUser!.uid);
    if (mounted) {
      setState(() {
        _user = userProfile;
        _newName = userProfile.name;
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      User updatedUser = _user!.copyWith(name: _newName);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update(updatedUser.toFirestore());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Profile'),
              Tab(text: 'Onboarding'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(
                children: [
                  FutureBuilder<User>(
                    future: Repository.getUserProfile(
                        auth.FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        _user =
                            snapshot.data; // Set _user with the fetched data
                        return Flexible(
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              padding: EdgeInsets.all(16),
                              children: [
                                TextFormField(
                                  initialValue: _newName,
                                  decoration:
                                      InputDecoration(labelText: 'Name'),
                                  onSaved: (value) => _newName = value ?? '',
                                  onChanged: (value) => _newName = value,
                                ),
                                ElevatedButton(
                                  onPressed: _updateUserData,
                                  child: Text('Update'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text('No user data found');
                      }
                    },
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                        onPressed: () {
                          ref
                              .read(themeProviderRef.notifier)
                              .toggleTheme(darkmode);
                          debugPrint(darkmode.toString());
                          setState(() {
                            darkmode = !darkmode;
                          });
                        },
                        child: const Text('Toggle Theme'),
                      );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // Repository.updateQuestProgress(23, 100, 0, "ivan");
                      },
                      child: const Text("Test"))
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  FutureBuilder<User>(
                    future: Repository.getUserProfile(
                        auth.FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        _user =
                            snapshot.data; // Set _user with the fetched data
                        return Flexible(
                          child: Form(
                            key: _formKeyTwo,
                            child: ListView(
                              padding: EdgeInsets.all(16),
                              children: [
                                TextFormField(
                                  initialValue: "placeholder",
                                  decoration: const InputDecoration(
                                      labelText:
                                          'Times available to train per week'),
                                  onSaved: (value) => _newName = value ?? '',
                                  onChanged: (value) => _newName = value,
                                ),
                                ElevatedButton(
                                  onPressed: _updateUserData,
                                  child: const Text('Update'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text('No user data found');
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
