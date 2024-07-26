import 'dart:io';
import 'dart:async';
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
  Completer<void> completer = Completer<void>();

  @override
  void initState() {
    super.initState();
    debugPrint("Downloading file for avatar ${widget.avatarId}");
    asyncInitialise();
  }

  @override
  void dispose() {
    completer.complete(); // Complete the completer if the widget is disposed
    super.dispose();
  }

  Future<void> asyncInitialise() async {
    await downloadAndStoreFile(widget.avatarId);
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

    try {
      await file.writeAsBytes(bytes);
      debugPrint("File written to ${file.path}");

      // Optionally, verify the file exists after writing
      if (await file.exists()) {
        debugPrint("File write successful");
        // Perform further actions if needed, e.g., updating the UI
      } else {
        debugPrint("File write failed: File does not exist after writing");
      }
    } catch (e) {
      debugPrint("Error writing file: $e");
      // Handle the error, e.g., by showing an error message to the user
    }

    debugPrint("File written to ${file.path}");

    if (!completer.isCompleted) {
      setState(() {
        localPath = file.path;
      });
    }
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
