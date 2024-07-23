import 'package:flutter/material.dart';

class Achievement extends StatelessWidget {
  final String picture;
  final String name;
  final String description;
  final int points;

  const Achievement({
    super.key,
    required this.picture,
    required this.name,
    required this.description,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(picture),
                radius: 36,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child:
                    Text('$points pts', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text(description, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
