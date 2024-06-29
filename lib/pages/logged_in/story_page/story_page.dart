import 'package:flutter/material.dart';

import 'story_tile.dart';

final items = List<String>.generate(10000, (i) => 'Item $i');

class StoryPage extends StatelessWidget {
  const StoryPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Main Story"),
          ),

          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                StoryTile(color: Colors.red),
                StoryTile(color: Colors.blue),
                StoryTile(color: Colors.orange),
                StoryTile(color: Colors.green),
                StoryTile(color: Colors.yellow),
              ],
            ),
          ),
          // Short Stories

          Align(
              alignment: Alignment.centerLeft,
              child: const Text("Short stories")),

          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                StoryTile(color: Colors.red),
                StoryTile(color: Colors.blue),
                StoryTile(color: Colors.orange),
                StoryTile(color: Colors.green),
                StoryTile(color: Colors.yellow),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
