import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/social_media_page/friend_adding_pages/friend_requests_list.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key});

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
    }.toList();

    setState(() {
      _searchResults = combinedResults;
    });
  }

  @override
  void initState() {
    super.initState();
    friendsList = [];
    Repository.getFriendList().then((value) {
      friendsList = value;
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
                MaterialPageRoute(
                    builder: (context) => const FriendRequestPage()),
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
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['name']),
                              Text(
                                "@${user['username']}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: friendsList.contains(user['uid'])
                              ? const Text("Added")
                              : IconButton(
                                  icon: const Icon(Icons.person_add),
                                  onPressed: () =>
                                      Repository.sendFriendRequest(user['uid']),
                                ),
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
