import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:o3d/o3d.dart';

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
      setState(() {
        debugPrint('templates ${templatesData.toString()}');
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
      debugPrint("yippepepepepepe");
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
      });
      debugPrint("Draft Avatar Saved");
    } else {
      debugPrint(saveResponse.reasonPhrase);
    }

    // Fetch Final Avatar
  }

  void onCardClick(String templateId) async {
    await createAndSaveAvatar(templateId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Choose an Avatar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isAvatarCreated
          ? AvatarDisplayWidget(finalAvatarUrl: finalAvatarUrl, userId: token)
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => onCardClick(templates[index]['id']),
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

class AvatarDisplayWidget extends StatefulWidget {
  final String finalAvatarUrl;
  final String userId;

  const AvatarDisplayWidget(
      {required this.finalAvatarUrl, required this.userId, super.key});

  @override
  State<AvatarDisplayWidget> createState() => _AvatarDisplayWidgetState();
}

class _AvatarDisplayWidgetState extends State<AvatarDisplayWidget> {
  O3DController controller = O3DController();
  List<dynamic> assets = [];

  Future<void> getUsableAssets() async {
    final response = await http.get(
        Uri.parse(
            'https://api.readyplayer.me/v1/assets?filter=usable-by-user-and-app&filterApplicationId=664f39ea83967c2d66c6d26b&filterUserId=6697b3a856bb8c004c2c8627'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.userId}',
          'X-APP-ID': '664f39ea83967c2d66c6d26b',
        });

    if (response.statusCode == 200) {
      String responseBody = response.body;
      var decodedResponse = jsonDecode(responseBody);
      var assetsData = decodedResponse['data'];
      setState(() {
        assets = assetsData;
      });
      debugPrint("works");
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    getUsableAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200, // Set a fixed width
            height: 200, // Set a fixed height
            child: O3D.asset(
              src: widget.finalAvatarUrl,
              controller: controller,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => {},
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            assets[index]['iconUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
