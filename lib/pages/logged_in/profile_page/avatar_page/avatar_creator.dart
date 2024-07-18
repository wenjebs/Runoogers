import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
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
  bool isAvatarCreated = false;
  String gender = '';
  String avatarId = '';

  @override
  void initState() {
    super.initState();
    initializeAsyncOperations();
  }

  Future<void> initializeAsyncOperations() async {
    await createAnonymousUser();
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
    final response = await http.get(
        Uri.parse('https://api.readyplayer.me/v2/avatars/templates'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    if (response.statusCode == 200) {
      String responseBody = response.body;
      var decodedResponse = jsonDecode(responseBody);
      var templatesData = decodedResponse['data'];
      setState(() {
        templates = templatesData;
      });
    } else {
      debugPrint(response.reasonPhrase);
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
      String responseBody = response.body;
      var decodedResponse = jsonDecode(responseBody);
      debugPrint("Draft Avatar ID: ${decodedResponse['data']['id']}");
      draftAvatarId = decodedResponse['data']['id'];
    } else {
      debugPrint(response.reasonPhrase);
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
      try {
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);

        var decodedResponse = jsonDecode(response.body);

        await userDoc.update({
          'avatarUrl': 'https://models.readyplayer.me/$draftAvatarId.glb',
          'avatarGender': decodedResponse['data']['gender'],
          'avatarId': draftAvatarId,
        });
        debugPrint("Avatar URL added to user document");
      } catch (e) {
        debugPrint("Error adding avatar URL to user document: $e");
      }
      debugPrint("Avatar Saved");

      // debugPrint("Draft Avatar Saved");
      //
    } else {
      debugPrint(saveResponse.reasonPhrase);
    }
  }

  Future<void> onCardClick(String templateId) async {
    await createAndSaveAvatar(templateId);
  }

  // Future<void> saveAvatar() async {
  //   final response = await http.put(
  //       Uri.parse('https://api.readyplayer.me/v2/avatars/$avatarId'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: 'Bearer $token',
  //       });

  //   if (response.statusCode == 200) {
  //     DocumentReference userDoc = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid);

  //     try {
  //       await userDoc.update({
  //         'avatarUrl': 'https://models.readyplayer.me/$avatarId.glb',
  //       });
  //       debugPrint("Avatar URL added to user document");
  //     } catch (e) {
  //       debugPrint("Error adding avatar URL to user document: $e");
  //     }
  //     debugPrint("Avatar Saved");
  //   } else {
  //     debugPrint(response.reasonPhrase);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose an Avatar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:
          // isAvatarCreated
          //     ? AvatarDisplayWidget(
          //         finalAvatarUrl: finalAvatarUrl,
          //         userId: token,
          //         gender: gender,
          //         avatarId: avatarId)
          //     :
          Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () async {
                      await onCardClick(templates[index]['id']);
                      setState(() {
                        gender = templates[index]['gender'];
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage(initialIndex: 0);
                      }));
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            templates[index]['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ));
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
