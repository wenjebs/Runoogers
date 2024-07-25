import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
import 'dart:convert';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/avatar_display_widget.dart';

class AvatarCreatorWidget extends StatefulWidget {
  final FirebaseAuth auth;
  const AvatarCreatorWidget({super.key, required this.auth});

  @override
  _AvatarCreatorWidgetState createState() => _AvatarCreatorWidgetState();
}

class _AvatarCreatorWidgetState extends State<AvatarCreatorWidget> {
  final String partnerSubdomain = 'goorunners';
  String token = '';
  List<dynamic> templates = [];
  String finalAvatarUrl = '';
  bool isAvatarCreated = false;
  String gender = '';
  String avatarId = '';

  @override
  void initState() {
    super.initState();
    debugPrint('Avatar Creation: Before creation');
    initializeAsyncOperations();
  }

  Future<void> initializeAsyncOperations() async {
    await createAnonymousUser();
    // debugPrint("avatar creator: anonymous user token: $token");
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
      debugPrint("Creating anon user ${response.reasonPhrase}");
      return false;
    }
  }

  Future<void> fetchTemplates() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.auth.currentUser!.uid)
        .get();

    final response = await http.get(
        Uri.parse('https://api.readyplayer.me/v2/avatars/templates'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    debugPrint("in function");
    if (response.statusCode == 200) {
      String responseBody = response.body;
      var decodedResponse = jsonDecode(responseBody);
      var templatesData = decodedResponse['data'];

      var userData = userDoc.data() as Map<String, dynamic>?;

      if (userDoc.exists && userData!.containsKey('avatarType')) {
        String avatarType = userDoc.get('avatarType');
        templatesData = templatesData
            .where((template) => template['imageUrl'] == avatarType)
            .toList();
        await createAndSaveAvatar(templatesData[0]['id']);
      }
      setState(() {
        debugPrint('templates ${templatesData.toString()}');
        templates = templatesData;
      });
    } else {
      debugPrint("fetchtemplates failed: ${response.reasonPhrase}");
    }
  }

  Future<void> createAndSaveAvatar(String templateId) async {
    final response = await http.post(
        Uri.parse(
            'https://api.readyplayer.me/v2/avatars/templates/$templateId'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({
          "data": {
            "partner": 'goorunners',
            "bodyType": 'fullbody',
          }
        }));

    var draftAvatarId = '';

    if (response.statusCode == 201) {
      debugPrint("success");
      String responseBody = response.body;
      var decodedResponse = jsonDecode(responseBody);
      debugPrint("Draft Avatar ID: ${decodedResponse['data']['id']}");
      draftAvatarId = decodedResponse['data']['id'];
      setState(() {
        gender = decodedResponse['data']['gender'];
        avatarId = draftAvatarId;
      });
    } else {
      debugPrint("create and save avatar failed: ${response.reasonPhrase}");
      debugPrint(response.statusCode.toString());
    }

    // Save Draft Avatar
    final saveResponse = await http.put(
      Uri.parse('https://api.readyplayer.me/v2/avatars/$draftAvatarId'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (saveResponse.statusCode == 200) {
      setState(() {
        finalAvatarUrl = 'https://models.readyplayer.me/$draftAvatarId.glb';
        isAvatarCreated = true;
        avatarId = draftAvatarId;
      });
      debugPrint("Draft Avatar Saved");
    } else {
      debugPrint(saveResponse.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to a specific route when the back button is pressed
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        initialIndex: 2,
                        repository: Repository(),
                      )),
            );
            // Or use Navigator.pop(context) if you just want to go back to the previous screen
          },
        ),
        title: const Text('Customise'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isAvatarCreated
          ? AvatarDisplayWidget(
              finalAvatarUrl: finalAvatarUrl,
              userId: token,
              gender: gender,
              avatarId: avatarId,
              auth: FirebaseAuth.instance)
          : const Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // This centers the column itself.
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                      height:
                          10), // Provides space between the indicator and the text.
                  Text(
                    "Loading...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
