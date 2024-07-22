import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:runningapp/database/repository.dart';

import 'story_detail_page.dart';

class StoryTileWithImage extends StatelessWidget {
  final Image image;
  final String shortTitle;
  final String title;
  final String description;
  final bool active;
  final String id;
  final String userID;
  final Repository repository;
  const StoryTileWithImage({
    super.key,
    required this.image,
    required this.shortTitle,
    required this.title,
    required this.description,
    required this.active,
    required this.id,
    required this.userID,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryDetailPage(
            repository: repository,
            image: image,
            title: title,
            description: description,
            id: id,
            userID: userID,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    shortTitle,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  child: image,
                ),
              ],
            ),
            active
                ? Positioned(
                    bottom: 50,
                    right: 3,
                    child: Container(
                      padding:
                          const EdgeInsets.all(2), // Adjust padding as needed
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("Active quest"),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
