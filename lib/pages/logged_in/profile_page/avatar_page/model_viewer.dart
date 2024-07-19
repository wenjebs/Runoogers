import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:o3d/o3d.dart';
import 'package:path_provider/path_provider.dart';

class GLBViewer extends StatefulWidget {
  final String avatarId;

  const GLBViewer({super.key, required this.avatarId});

  @override
  _GLBViewerState createState() => _GLBViewerState();
}

class _GLBViewerState extends State<GLBViewer> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    debugPrint("Downloading file for avatar ${widget.avatarId}");
    downloadAndStoreFile(widget.avatarId);
  }

  Future<void> downloadAndStoreFile(String avatarId) async {
    final url =
        'https://api.readyplayer.me/v2/avatars/$avatarId.glb?preview=true';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/avatar.glb');

    // Check if the file exists and delete it before writing the new file
    if (await file.exists()) {
      debugPrint("deleting");
      await file.delete();
    }

    await file.writeAsBytes(bytes);

    debugPrint("File written to ${file.path}");

    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: localPath == null
          ? const CircularProgressIndicator()
          : SizedBox(
              height: 300, width: 300, child: O3D(src: 'file://${localPath!}')),
    );
  }
}
