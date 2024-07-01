import 'package:flutter/material.dart';

import 'story_detail_page.dart';

class StoryTileWithImage extends StatelessWidget {
  final Image image;
  final String shortTitle;
  final String title;
  final String description;
  final bool active;
  final String id;
  final String userID;

  const StoryTileWithImage({
    super.key,
    required this.image,
    required this.shortTitle,
    required this.title,
    required this.description,
    required this.active,
    required this.id,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryDetailPage(
            image: image,
            title: title,
            description: description,
            id: id,
            userID: userID,
          ),
        ),
      ),
      child: Card(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 300,
                  child: image,
                ),
                Text(shortTitle),
              ],
            ),
            active
                ? Positioned(
                    top: 20,
                    right: 2,
                    child: Container(
                      padding:
                          const EdgeInsets.all(2), // Adjust padding as needed
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      child: const Text("Active quest"),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
