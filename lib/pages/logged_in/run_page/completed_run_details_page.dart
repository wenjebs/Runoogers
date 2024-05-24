import 'package:flutter/material.dart';

class CompletedRunDetailsPage extends StatefulWidget {
  const CompletedRunDetailsPage({super.key, required int time});

  @override
  State<CompletedRunDetailsPage> createState() {
    return _CompletedRunDetailsPageState();
  }
}

class _CompletedRunDetailsPageState extends State<CompletedRunDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Run Details'),
      ),
      body: Container(
          // Add your content here
          ),
    );
  }
}
