import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

class TestWidget extends StatelessWidget {
  final String avatarId;

  const TestWidget({super.key, required this.avatarId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test widget'),
          automaticallyImplyLeading: true,
        ),
        body: SizedBox(
            height: 200,
            width: 200,
            child: O3D(src: 'https://models.readyplayer.me/$avatarId.glb')));
  }
}
