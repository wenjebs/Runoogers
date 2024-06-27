import 'package:flutter/material.dart';

class StoryDetailPage extends StatelessWidget {
  const StoryDetailPage({super.key});

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
          ElevatedButton(onPressed: () {}, child: const Text("Start"))
        ],
      ),
    );
  }
}
