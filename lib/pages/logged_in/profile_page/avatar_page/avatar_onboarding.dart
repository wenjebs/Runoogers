import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';

class AvatarOnboarding extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  const AvatarOnboarding(
      {super.key,
      required this.auth,
      required this.firestore,
      required this.storage});

  @override
  AvatarOnboardingState createState() => AvatarOnboardingState();
}

class AvatarOnboardingState extends State<AvatarOnboarding> {
  bool isLoading = false;
  bool fetchingTemplates = true;
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
    debugPrint("avatar creator: anonymous user token: $token");
    await fetchTemplates();
    setState(() {
      fetchingTemplates = false;
    });
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
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userDoc.set({
        'rpmUserId': decodedResponse['data']['id'],
        'rpmToken': decodedResponse['data']['token'],
      }, SetOptions(merge: true));
      return true;
    } else {
      debugPrint("Creating anon user ${response.reasonPhrase}");
      return false;
    }
  }

  Future<void> fetchTemplates() async {
    final response = await http.get(
        Uri.parse('https://api.readyplayer.me/v2/avatars/templates'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
    debugPrint("in avatar onboarding");
    if (response.statusCode == 200) {
      String responseBody = response.body;
      var decodedResponse = jsonDecode(responseBody);
      var templatesData = decodedResponse['data'];

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
        avatarId = draftAvatarId;
      });
      debugPrint("Draft Avatar Saved");
    } else {
      debugPrint(saveResponse.reasonPhrase);
    }
    debugPrint("before saving pfp");
    final pfpResponse = await http.get(Uri.parse(
        'https://models.readyplayer.me/$draftAvatarId.png?expression=happy&pose=power-stance'));
    if (pfpResponse.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/avatar.png');
      debugPrint("pfp response: 200");
      if (await file.exists()) {
        await file.delete();
      }

      await file.writeAsBytes(pfpResponse.bodyBytes);
    } else {
      throw Exception('Failed to load avatar');
    }

    String userId = widget.auth.currentUser!.uid;

    debugPrint("tryibng tos ave to firestore");
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/avatar.png');
    TaskSnapshot snapshot =
        await widget.storage.ref('userAvatars/$userId.png').putFile(file);
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    await widget.firestore.collection('users').doc(userId).update({
      'profilePic': downloadUrl,
      'avatarUrl': finalAvatarUrl,
      'avatarId': avatarId
    });

    if (mounted) {
      setState(() {
        isAvatarCreated = true;
        isLoading = false;
      });
    }
  }

  void onCardClick(String templateId) async {
    await createAndSaveAvatar(templateId);
  }

  @override
  Widget build(BuildContext context) {
    if (isAvatarCreated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(initialIndex: 0, repository: Repository()),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Choose an Avatar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: fetchingTemplates
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Fetching avatars...",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface)),
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            )
          : isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Creating your avatar, please hold on...",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSurface)),
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: templates.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                onCardClick(templates[index]['id']);
                                setState(() {
                                  gender = templates[index]['gender'];
                                });

                                var userId =
                                    FirebaseAuth.instance.currentUser?.uid;
                                if (userId != null) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .update({
                                        'gender': templates[index]['gender'],
                                        'avatarType': templates[index]
                                            ['imageUrl'],
                                      })
                                      .then((_) => debugPrint(
                                          'Avatar type updated successfully'))
                                      .catchError((error) => debugPrint(
                                          'Failed to update avatar type: $error'));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          templates[index]['imageUrl'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    if (finalAvatarUrl.isNotEmpty)
                      Text(
                        'Final Avatar URL: $finalAvatarUrl',
                      ),
                  ],
                ),
    );
  }
}
