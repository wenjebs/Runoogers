import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:runningapp/pages/logged_in/run_page/run_page.dart';

class StoryDetailPage extends StatefulWidget {
  const StoryDetailPage({super.key});

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
        title: const Text("Story Detail Page"),
      ),
      body: Column(
        children: [
          // STORY IMAGE
          Center(
            child: Image.network(
                "https://fastly.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI"),
          ),

          // Chapter
          const Text("Chapter 1"),

          // Title
          const Text("Title"),

          // Description
          const Text("The start of a beautiful story..."),

          // Start button
          ElevatedButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      // TODO, handle no permission unhandled exception
                      builder: (context) => const RunPage(
                        storyRun: true,
                      ),
                    ),
                  ),
              child: const Text("Start")),

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
