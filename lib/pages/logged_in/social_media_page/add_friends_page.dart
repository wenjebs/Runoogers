import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/friend_requests_list.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key});

  @override
  State<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _searchResults =
      []; // Step 1: Store search results

  void searchUser() {
    final query = _searchController.text.trim();
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: query)
        .get()
        .then((snapshot) {
      setState(() {
        // Store the search results in _searchResults
        _searchResults = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendRequestPage()),
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
                  onPressed: searchUser, // Call the search method on press
                ),
              ),
            ),
            Expanded(
              // Use Expanded to fill the remaining space
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return ListTile(
                    title: Text(user['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () =>
                          Repository.sendFriendRequest(user['uid']),
                    ), // Assuming 'name' is a field in your documents
                    // Add other ListTile properties if needed
                  );
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
