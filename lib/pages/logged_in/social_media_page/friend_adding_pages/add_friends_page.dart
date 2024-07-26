import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/profile_peek.dart';
import 'package:runningapp/pages/logged_in/social_media_page/friend_adding_pages/friend_requests_list.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key, required this.repository});
  final Repository repository;

  @override
  State<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _searchController = TextEditingController();

  List<String> friendsList = [];

  List<Map<String, dynamic>> _searchResults =
      []; // Step 1: Store search results

  void searchUser() async {
    final query = _searchController.text.trim();
    final nameQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: query)
        .where('uid', isNotEqualTo: user.uid)
        .get();

    final usernameQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: query)
        .where('uid', isNotEqualTo: user.uid)
        .get();

    // Combine the results of the two queries, avoiding duplicates
    final combinedResults = {
      ...nameQuerySnapshot.docs.map((doc) => doc.data()),
      ...usernameQuerySnapshot.docs.map((doc) => doc.data()),
    }.toList().toSet().toList();

    setState(() {
      _searchResults = combinedResults;
    });
  }

  @override
  void initState() {
    super.initState();
    friendsList = [];
    widget.repository.getFriendList().then((value) {
      friendsList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FriendRequestPage(
                          repository: widget.repository,
                        )),
              );
            },
          ),
        ],
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for users',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchUser,
                ),
              ),
            ),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(
                      child: Text("No users found"),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return ProfilePeek(user: UserModel.fromMap(user));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
