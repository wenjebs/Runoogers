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
    createAnonymousUser();
    // .then((value) {
    //   token = value;
    //   debugPrint('after create');
    //   fetchTemplates().catchError((error) {
    //     debugPrint("Error fetching templates: $error");
    //   });
    // }).catchError((error) {
    //   debugPrint("Error creating anonymous user: $error");
    // });
  }

  Future<void> createAnonymousUser() async {
    var request = http.Request(
        'POST', Uri.parse('https://goorunners.readyplayer.me/api/users'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);
      setState(() {
        token = decodedResponse['data']['token'];
      });
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  Future<void> fetchTemplates() async {
    var headers = {'Authorization': '••••••'};
    var request = http.Request(
        'GET', Uri.parse('https://api.readyplayer.me/v2/avatars/templates'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    setState(() {
      // templates = jsonDecode(response.stream.bytesToString())['data'];
    });
  }

  Future<void> createAndSaveAvatar(String templateId) async {
    // Create Draft Avatar
    final draftResponse = await http.post(
      Uri.parse('https://api.readyplayer.me/v2/avatars/templates/$templateId'),
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'partner': partnerSubdomain,
        'bodyType': 'fullbody',
      }),
    );
    final draftData = jsonDecode(draftResponse.body);
    final draftAvatarId = draftData['data']['id'];

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
