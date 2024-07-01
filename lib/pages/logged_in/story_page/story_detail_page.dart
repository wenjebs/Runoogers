import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';

class StoryDetailPage extends StatefulWidget {
  final Image image;
  final String title;
  final String description;
  final String id;
  final String userID;

  const StoryDetailPage(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.userID,
      required this.id});

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story details"),
      ),
      body: Column(
        children: [
          // STORY IMAGE
          Center(child: widget.image),

          // Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Description
          Expanded(
              child: SingleChildScrollView(
                  child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(widget.description),
          ))),

          // Start button
          ElevatedButton(
              // onPressed: () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         // TODO, handle no permission unhandled exception
              //         builder: (context) => const RunPage(
              //           storyRun: true,
              //         ),
              //       ),
              //     ),
              onPressed: () {
                Repository.setUserActiveStory(widget.userID, widget.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Active story set successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Make active quest")),

          // Audio Test
          ElevatedButton(
              onPressed: () async {
                await player.setAsset('lib/assets/audio/cow.mp3');
                player.play();
              },
              child: const Text("Moo"))
        ],
      ),
    );
  }
}
