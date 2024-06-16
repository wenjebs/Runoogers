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
    final user = FirebaseAuth.instance.currentUser;
    final userInfoAsyncValue = ref.watch(userInfoProvider);
    var friendUids = <String>[];
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
    final postStream =
        GetUserPostService().getPosts(["oRzn1b8M3mN1322UewNXF0TCGBx1"]);
    return userInfoAsyncValue.when(
      data: (userInfo) {
        return Scaffold(
          body: Container(
            child: StreamBuilder(
              builder: (context, snapshot) => Builder(
                builder: (context) {
                  List posts = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return RunningPost(
                        id: posts[index]['id'],
                        userId: posts[index]['userId'],
                        caption: posts[index]['post'],
                        run: posts[index]['run'],
                        likes: posts[index]['likes'],
                        comments: posts[index]['comments'],
                      );
                    },
                  );
                },
              ),
              stream: postStream,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostCreationPage()),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
