import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';
import 'package:runningapp/pages/logged_in/story_page/models/quests_model.dart';
import 'package:runningapp/pages/logged_in/story_page/story_tile_with_image.dart';

import 'active_quest_display_page.dart';
import 'story_tile.dart';

class StoryPage extends ConsumerWidget {
  const StoryPage({super.key});

  final stories = null;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInformationProvider).asData?.value;
    // debugPrint(userInfo.toString());
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
              "Main Stories",
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
                      image: Image.network(stories[index].getImageURL,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image has finished loading
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null, // Display the loading progress
                          ),
                        );
                      }),
                      shortTitle: stories[index].getShortTitle,
                      title: stories[index].getTitle,
                      description: stories[index].getDescription,
                      active: userInfo?['activeStory'] == stories[index].getId,
                      id: stories[index].getId,
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
                onPressed: () async {
                  // debugPrint(userInfo?['activeStory']);
                  final List<Quest> quests = await Repository.getQuests(
                    userInfo?['activeStory'],
                  );
                  // debugPrint("ahh");
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActiveQuestDisplayPage(
                          activeStory: userInfo?['activeStory'],
                          quests: quests,
                        ),
                      ),
                    );
                  }
                },
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
