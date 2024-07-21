import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:runningapp/database/repository.dart';

class StoryDetailPage extends StatefulWidget {
  final Repository repository;
  final Image image;
  final String title;
  final String description;
  final String id;
  final String userID;

  const StoryDetailPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.userID,
    required this.id,
    required this.repository,
  });

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  late AudioPlayer player;
  bool active = false;
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
            onPressed: active
                ? () {}
                : () {
                    widget.repository
                        .setUserActiveStory(widget.userID, widget.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        dismissDirection: DismissDirection.up,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height - 150,
                            left: 10,
                            right: 10),
                        content: const Text('Active story set successfully'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      active = true;
                    });
                  },
            child: active
                ? const Text("This quest is currently active!")
                : const Text("Make active quest"),
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 10,
            right: 10),
        content: Text(s),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
