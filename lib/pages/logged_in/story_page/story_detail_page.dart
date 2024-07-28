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
        title: const Text("Details"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Image
            SizedBox(
              width: double.infinity,
              child: widget.image,
            ),

            // Profile Details
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: active
                          ? null
                          : () {
                              widget.repository
                                  .setUserActiveStory(widget.userID, widget.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Active story set successfully'),
                                  duration: Duration(seconds: 2),
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
                  ),
                ],
              ),
            ),
          ],
        ),
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
