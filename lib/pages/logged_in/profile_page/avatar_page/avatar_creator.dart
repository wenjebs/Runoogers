import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:o3d/o3d.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/models/user.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/model_viewer.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/testwidget.dart';

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
        avatarId = draftAvatarId;
      });
      debugPrint("Draft Avatar Saved");
    } else {
      debugPrint(saveResponse.reasonPhrase);
    }
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
          ? AvatarDisplayWidget(
              finalAvatarUrl: finalAvatarUrl,
              userId: token,
              gender: gender,
              avatarId: avatarId)
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
                          onTap: () {
                            onCardClick(templates[index]['id']);
                            setState(() {
                              gender = templates[index]['gender'];
                            });
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

class AvatarDisplayWidget extends StatefulWidget {
  final String finalAvatarUrl;
  final String userId;
  final String gender;
  final String avatarId;

  const AvatarDisplayWidget(
      {required this.finalAvatarUrl,
      required this.userId,
      required this.gender,
      required this.avatarId,
      super.key});

  @override
  State<AvatarDisplayWidget> createState() => _AvatarDisplayWidgetState();
}

class _AvatarDisplayWidgetState extends State<AvatarDisplayWidget>
    with TickerProviderStateMixin {
  O3DController controller = O3DController();
  List<dynamic> assets = [];
  List<String> categories = [
    'bottom',
    'eye',
    'eyebrows',
    'eyeshape',
    'facemask',
    'faceshape',
    'facewear',
    'footwear',
    'glasses',
    'hair',
    'beard',
    'headwear',
    'lipshape',
    'noseshape',
    'outfit',
    'shirt',
    'top',
    'costume'
  ];
  String currentAvatarUrl = '';
  int glbViewerKey = 0; // TODO THIS IS DAMN SCUFFED
  Key avatarKey = UniqueKey();
  String userId = '';

  Future<List<dynamic>> getUsableAssets(String category) async {
    debugPrint("userId: ${auth.FirebaseAuth.instance.currentUser!.uid}");
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid);

    try {
      DocumentSnapshot userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        // Assuming 'rpmUserId' is the field name in the document
        final rpmUserId = userSnapshot.get('rpmUserId');
        debugPrint("rpmUserId: $rpmUserId");

        setState(() {
          userId = rpmUserId;
        });
      } else {
        debugPrint('No such user!');
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }

    final response = await http.get(
        Uri.parse(
            'https://api.readyplayer.me/v1/assets?filter=usable-by-user-and-app&filterApplicationId=664f39ea83967c2d66c6d26b&filterUserId=$userId&gender=neutral&gender=${widget.gender}&type=$category&limit=50'),
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
      return assetsData;
    } else {
      debugPrint(response.reasonPhrase);
      return [];
    }
  }

  Future<void> equipAsset(String assetId, String category) async {
    debugPrint("avatar ID: ${widget.avatarId}, asset ID: $assetId");
    final response = await http.patch(
        Uri.parse('https://api.readyplayer.me/v2/avatars/${widget.avatarId}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.userId}',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({
          "data": {
            "assets": {category: assetId}
          }
        }));

    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
      setState(() {
        glbViewerKey++;
        avatarKey = UniqueKey();
      });
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  Future<void> saveAvatar() async {
    final response = await http.put(
        Uri.parse('https://api.readyplayer.me/v2/avatars/${widget.avatarId}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.userId}',
        });

    if (response.statusCode == 200) {
      debugPrint("Avatar Saved");
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case 'eyebrows':
        return FontAwesomeIcons.faceSmile;
      case 'eyeshape':
        return FontAwesomeIcons.eye;
      case 'facemask':
        return FontAwesomeIcons.headSideMask;
      case 'faceshape':
        return FontAwesomeIcons.user;
      case 'facewear':
        return FontAwesomeIcons.glasses;
      case 'footwear':
        return FontAwesomeIcons.shoePrints;
      case 'glasses':
        return FontAwesomeIcons.glasses;
      case 'hair':
        return FontAwesomeIcons.hatCowboy;
      case 'headwear':
        return FontAwesomeIcons.hatWizard;
      case 'lipshape':
        return FontAwesomeIcons.faceKissWinkHeart;
      case 'noseshape':
        return Icons.face;
      case 'outfit':
        return FontAwesomeIcons.shirt;
      case 'shirt':
        return FontAwesomeIcons.shirt;
      case 'top':
        return FontAwesomeIcons.shirt;
      case 'costume':
        return FontAwesomeIcons.mask;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  Future<void> fetchAndCacheAssets(String category) async {
    if (AssetCacheManager.hasAssets(category)) {
      // If assets are cached, use them
      setState(() {
        assets = AssetCacheManager.getAssets(category)!;
      });
    } else {
      // Simulate fetching assets from the network
      var fetchedAssets = await getUsableAssets(category);
      // Cache the fetched assets
      AssetCacheManager.cacheAssets(category, fetchedAssets);
      // Update the UI
      setState(() {
        assets = fetchedAssets;
      });
    }
  }

  Future<void> fetchUserId() async {
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.FirebaseAuth.instance.currentUser!.uid);

    try {
      DocumentSnapshot userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        // Assuming 'rpmUserId' is the field name in the document
        final rpmUserId = userSnapshot.get('rpmUserId');
        setState(() {
          userId = rpmUserId;
        });
      } else {
        debugPrint('No such user!');
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint(userId);
    getUsableAssets(categories[0]);
    currentAvatarUrl = widget.finalAvatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          saveAvatar();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestWidget(avatarId: widget.avatarId)),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
      body: Column(
        children: [
          GLBViewer(avatarId: widget.avatarId, key: avatarKey),
          const Divider(
            height: 20, // Adjust the divider's height as needed
            thickness: 2, // Adjust the thickness of the divider line
            color: Colors.grey, // Adjust the color of the divider line
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2, // Takes up 20% of the screen horizontally
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: InkWell(
                          onTap: () {
                            fetchAndCacheAssets(categories[index]);
                          },
                          child: Icon(getIconForCategory(categories[index])),
                        ),
                      );
                    },
                  ),
                ),
                const VerticalDivider(
                  width: 1, // Width of the divider line
                  color: Colors.black, // Color of the divider line
                ),
                Expanded(
                  flex:
                      6, // Adjusted for 30% of the screen horizontally, or as needed
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: InkWell(
                          onTap: () {
                            equipAsset(
                                assets[index]['id'], assets[index]['type']);
                          },
                          child: ClipRect(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(
                                fit: BoxFit
                                    .cover, // This ensures the image covers the widget area without losing aspect ratio
                                child: Image.network(
                                  assets[index]['iconUrl'],
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AssetCacheManager {
  static final Map<String, List<dynamic>> _cache = {};

  static void cacheAssets(String category, List<dynamic> assets) {
    _cache[category] = assets;
  }

  static List<dynamic>? getAssets(String category) {
    return _cache[category];
  }

  static bool hasAssets(String category) {
    return _cache.containsKey(category);
  }
}
