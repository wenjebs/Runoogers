import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/models/social_media_post.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/social_media_page/normal_post_creation_page.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';

class SocialMediaPage extends ConsumerWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendUids = ref.watch(friendsProvider);
// TODO Look into pagination
    return friendUids.when(
      data: (friendUids) {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: GetUserPostService().getPosts(friendUids),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final posts = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String,
                    dynamic>; // Cast to Map<String, dynamic> for null safety
                return Post(
                  id: data['id'] ?? '',
                  userId: data['userId'] ?? '',
                  caption: data['caption'] ?? '',
                  likes: data['likes'] ?? 0,
                  achievementDescription: data[
                      'achievementDescription'], // No need for ??, null is acceptable
                  achievementTitle: data[
                      'achievementTitle'], // Assuming these can also be null
                  achievementImageUrl: data['achievementImageUrl'],
                  achievementPoints: data['achievementPoints'],
                  runImageUrl: data['runImageUrl'],
                );
              }).toList();
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return RunningPost(
                    post: post,
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PostCreationPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
