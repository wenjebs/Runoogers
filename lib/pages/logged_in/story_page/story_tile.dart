import 'package:flutter/material.dart';

import 'story_detail_page.dart';

class StoryTile extends StatelessWidget {
  final Color color;

  const StoryTile({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => StoryDetailPage())),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            color: color,
          ),
          Text("Chapter 1"),
          Text("2km"),
        ],
      ),
    );
  }
}
