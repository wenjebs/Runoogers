import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AvatarCreatorWidget extends StatefulWidget {
  const AvatarCreatorWidget({super.key});

  @override
  _AvatarCreatorWidgetState createState() => _AvatarCreatorWidgetState();
}

class _AvatarCreatorWidgetState extends State<AvatarCreatorWidget> {
  final String partnerSubdomain = 'goorunners';
  String token = '';
  List<dynamic> templates = [];
  String finalAvatarUrl = '';

  @override
  void initState() {
    super.initState();
    debugPrint('before create');
    initializeAsyncOperations();
  }

  Future<void> initializeAsyncOperations() async {
    await createAnonymousUser();
    debugPrint(token);
    await fetchTemplates();
  }

  Future<bool> createAnonymousUser() async {
    var request = http.Request(
        'POST', Uri.parse('https://goorunners.readyplayer.me/api/users'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);
      setState(() {
        token = decodedResponse['data']['token'];
      });
      return true;
    } else {
      debugPrint(response.reasonPhrase);
      return false;
    }
  }

  Future<void> fetchTemplates() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
        'GET', Uri.parse('https://api.readyplayer.me/v2/avatars/templates'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    debugPrint("in function");
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);
      var templatesData = decodedResponse['data'];
      setState(() {
        debugPrint('templates ${templatesData.toString()}');
        templates = templatesData;
      });
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  Future<void> createAndSaveAvatar(String templateId) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.readyplayer.me/v2/avatars/templates/645cd1cef23d0562d3f9d28d'));
    request.body = json.encode({
      "data": {"partner": "goorunners", "bodyType": "fullbody"}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var draftAvatarId = '';

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);
      debugPrint("Draft Avatar ID: ${decodedResponse['data']['id']}");
      draftAvatarId = decodedResponse['data']['id'];
    } else {
      debugPrint(response.reasonPhrase);
    }

    // Save Draft Avatar
    await http.put(
      Uri.parse('https://api.readyplayer.me/v2/avatars/$draftAvatarId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // Fetch Final Avatar
    setState(() {
      finalAvatarUrl = 'https://models.readyplayer.me/$draftAvatarId.glb';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("hi"),
          Expanded(
            child: ListView.builder(
              itemCount: templates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(templates[index]['title']),
                  onTap: () => createAndSaveAvatar(templates[index]['id']),
                );
              },
            ),
          ),
          if (finalAvatarUrl.isNotEmpty)
            Text('Final Avatar URL: $finalAvatarUrl'),
        ],
      ),
    );
  }
}
