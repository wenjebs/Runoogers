import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/social_media_page/components/running_post.dart';
import 'package:runningapp/pages/logged_in/social_media_page/post_creation_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/pages/logged_in/social_media_page/services/get_user_post_service.dart';

class SocialMediaPage extends ConsumerWidget {
  const SocialMediaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendUids = ref.watch(friendsProvider);
    // TODO look into pagination
    // final Future<List<List<RunningPost>>> posts = FirebaseFirestore.instance.collection('posts').where('uid', whereIn: friendUids).snapshots().map((snapshot) {
    //   return snapshot.docs.map((doc) {
    //     return RunningPost(
    //       id: doc['id'],
    //       userId: doc['userId'],
    //       caption: doc['post'],
    //       run: doc['run'],
    //       likes: doc['likes'],
    //       comments: doc['comments'],
    //     );
    //   }).toList();
    // }).toList();
    return friendUids.when(
      data: (friendUids) {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: GetUserPostService().getPosts(friendUids),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print("something wrong with the stream");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final posts = snapshot.data!.docs.map((doc) {
                return RunningPost(
                  id: doc['id'],
                  userId: doc['userId'],
                  caption: doc['caption'],
                  run: doc['run'],
                  likes: doc['likes'],
                  comments: List<String>.from(
                      doc['comments'].map((item) => item.toString())),
                );
              }).toList();
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return posts[index];
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostCreationPage()),
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
