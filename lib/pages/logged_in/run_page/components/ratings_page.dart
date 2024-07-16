import 'package:flutter/material.dart';

class RatingPage extends StatelessWidget {
  final Function(int) onRated;

  const RatingPage({super.key, required this.onRated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How difficult was it?')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: CircleAvatar(child: Text('${index + 1}')),
              onPressed: () => onRated(index + 1),
            );
          }),
        ),
      ),
    );
  }
}
