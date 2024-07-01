import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/story_page/story_tile_with_image.dart';

import 'story_tile.dart';

final items = List<String>.generate(10000, (i) => 'Item $i');

class StoryPage extends ConsumerWidget {
  const StoryPage({super.key});

  final stories = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInformationProvider).asData?.value;
    return Scaffold(
      body: Column(
        children: [
          // SEARCH BAR
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchBar(
              leading: Icon(Icons.search),
            ),
          ),

          // Main Stories
          Align(
            alignment: Alignment.center,
            child: Text(
              "Main Quests",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),

          SizedBox(
            height: 250,
            child: FutureBuilder(
              future: Repository.getStories(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final stories = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    // debugPrint(stories[index].toString());
                    return StoryTileWithImage(
                      image: Image.network(stories[index]['imageURL']),
                      shortTitle: stories[index]['shortTitle'],
                      title: stories[index]['title'],
                      description: stories[index]['description'],
                      active: userInfo?['activeStory'] == stories[index]['id'],
                      id: stories[index]['id'],
                      userID: userInfo?['uid'],
                    );
                  },
                );
              },
            ),
          ),
          // Short Stories

          Align(
            alignment: Alignment.center,
            child: Text(
              "Side quests",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: const [
                StoryTile(color: Colors.red),
                StoryTile(color: Colors.blue),
                StoryTile(color: Colors.orange),
                StoryTile(color: Colors.green),
                StoryTile(color: Colors.yellow),
              ],
            ),
          ),

          // view active quests
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Active Quests",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
