import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/social_media_post.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialMediaPage extends ConsumerWidget {
  final bool showFloatingActionButton;
  final Repository repository;
  final FirebaseAuth auth;
  final TextEditingController _captionController = TextEditingController();

  SocialMediaPage({
    super.key,
    this.showFloatingActionButton = true,
    required this.auth,
    required this.repository,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendUids = ref.watch(friendsProvider);

    void addPost() {
      final caption = _captionController.text;
      if (caption.isNotEmpty) {
        repository.addPost('posts', {
          'timestamp': FieldValue.serverTimestamp(),
          'caption': caption,
          'userId': auth.currentUser!.uid,
          'likes': 0,
          'photoUrl':
              'https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8189.jpg',
        });
        _captionController.clear();
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (showFloatingActionButton) ...[
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _captionController,
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 40),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send,
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: addPost,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              expandedHeight: 120.0,
            ),
          ],
          friendUids.when(
            data: (friendUids) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: GetUserPostService().getPosts(friendUids),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final posts = snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return Post.fromMap(data);
                      }).toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return RunningPost(
                            repository,
                            post: post,
                          );
                        },
                      );
                    },
                  );
                },
                childCount: 1,
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
