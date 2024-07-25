import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:o3d/o3d.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/pages/logged_in/home_page/home_page.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/asset_display_widget.dart';
import 'package:runningapp/pages/logged_in/profile_page/avatar_page/model_viewer.dart';

class AvatarDisplayWidget extends StatefulWidget {
  final String finalAvatarUrl;
  final String userId;
  final String gender;
  final String avatarId;
  final FirebaseAuth auth;

  const AvatarDisplayWidget(
      {required this.finalAvatarUrl,
      required this.userId,
      required this.gender,
      required this.avatarId,
      required this.auth,
      super.key});

  @override
  State<AvatarDisplayWidget> createState() => _AvatarDisplayWidgetState();
}

class _AvatarDisplayWidgetState extends State<AvatarDisplayWidget>
    with TickerProviderStateMixin {
  O3DController controller = O3DController();
  List<dynamic> assets = [];

  // for fetching assets
  List<String> categories = [
    'outfit',
  ];
  String currentAvatarUrl = '';
  int glbViewerKey = 0; // TODO THIS IS DAMN SCUFFED
  Key avatarKey = UniqueKey();
  String userId = '';

  bool isCustomised = false;

  Future<void> getUsableAssets(String category) async {
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.auth.currentUser!.uid);

    QuerySnapshot existingAssets = await userDoc.collection('assets').get();

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

    if (existingAssets.docs.isNotEmpty) {
      List<dynamic> existingAssetsData =
          existingAssets.docs.map((doc) => doc.data()).toList();
      setState(() {
        assets = existingAssetsData;
      });
      debugPrint("Loaded assets from Firestore.");
    } else {
      final response = await http.get(
          Uri.parse(
              'https://api.readyplayer.me/v1/assets?filter=usable-by-user-and-app&filterApplicationId=664f39ea83967c2d66c6d26b&filterUserId=$userId&gender=neutral&gender=${widget.gender}&type=$category&limit=16'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${widget.userId}',
            'X-APP-ID': '664f39ea83967c2d66c6d26b',
          });

      if (response.statusCode == 200) {
        String responseBody = response.body;
        var decodedResponse = jsonDecode(responseBody);
        // debugPrint(decodedResponse['data'].toString());
        List<dynamic> assetsData = decodedResponse['data'];

        for (var asset in assetsData) {
          Map<String, dynamic> assetData = {
            'id': asset['id'],
            'name': asset['name'],
            'organizationId': asset['organizationId'],
            'locked': asset['locked'],
            'type': asset['type'],
            'bodyType': asset['bodyType'],
            'editable': asset['editable'],
            'gender': asset['gender'],
            'hasApps': asset['hasApps'],
            'campaignIds': asset['campaignIds'] ??
                [], // Handle optional fields with a default value
            'iconUrl': asset['iconUrl'],
            'badgeText': asset['badgeText'],
            'badgeLogoUrl': asset['badgeLogoUrl'],
            'faceBlendShapes': asset['faceBlendShapes'] ?? [],
            'hairStyle': asset['hairStyle'] ?? '',
            'eyebrowStyle': asset['eyebrowStyle'] ?? '',
            'eyeStyle': asset['eyeStyle'] ?? '',
            'beardStyle': asset['beardStyle'] ?? '',
            'glassesStyle': asset['glassesStyle'] ?? '',
            'lockedCategories': asset['lockedCategories'] ?? [],
            'iconGlow': asset['iconGlow'] ?? false,
            'position': asset['position'],
            'price': 500,
            'unlocked': false,
          };
          await userDoc.collection('assets').add(assetData);
          debugPrint("Asset data stored successfully in Firestore.");
        }
        List<dynamic> listedAssetsData =
            existingAssets.docs.map((doc) => doc.data()).toList();
        setState(() {
          assets = listedAssetsData;
        });
        debugPrint("Assets data stored successfully in Firestore.");

        debugPrint("getUsableAssets: Assets retrieved");
      } else {
        debugPrint(response.reasonPhrase);
      }
    }
  }

  Future<void> equipAsset(String assetId, String category) async {
    debugPrint(
        "avatar ID: ${widget.avatarId}, asset ID: $assetId category: $category");
    final response = await http.patch(
        Uri.parse('https://api.readyplayer.me/v2/avatars/${widget.avatarId}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.userId}',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({
          "data": {
            "assets": {convertToAvatarAttribute(category): assetId}
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
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.auth.currentUser!.uid);

    final response = await http.put(
        Uri.parse('https://api.readyplayer.me/v2/avatars/${widget.avatarId}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${widget.userId}',
        });

    if (response.statusCode == 200) {
      await userDoc.update({
        'avatarUrl': 'https://models.readyplayer.me/${widget.avatarId}.glb',
        'avatarId': widget.avatarId,
      }).then((_) {
        debugPrint("Avatar URL updated in Firestore new");
      }).catchError((error) {
        debugPrint("Error updating avatar URL in Firestore: $error");
      });
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  String convertToAvatarAttribute(String category) {
    switch (category) {
      case 'beard':
        return "beardStyle";
      case 'eye':
        return "eyeColor";
      case 'eyebrows':
        return "eyebrowStyle";
      case 'eyeshape':
        return "eyeShape";
      case 'facemask':
        return "faceMask";
      case 'faceshape':
        return "faceShape";
      case 'glasses':
        return "glasses";
      case 'hair':
        return "hairStyle";
      case 'headwear':
        return "headwear";
      case 'lipshape':
        return "lipShape";
      case 'noseshape':
        return "noseShape";
      case 'outfit':
        return "outfit";
      case 'shirt':
        return "shirt";
      default:
        return category; // Default case for unmapped categories
    }
  }

  Future<void> fetchUserId() async {
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.auth.currentUser!.uid);

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
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevents the dialog from closing until we manually do so
            builder: (BuildContext context) {
              return const Dialog(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text("Saving..."),
                    ],
                  ),
                ),
              );
            },
          );

          await saveAvatar();

          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                initialIndex: 2,
                repository: Repository(),
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
      body: Column(
        children: [
          isCustomised
              ? SizedBox(
                  height: 300,
                  width: 300,
                  child: GLBViewer(avatarId: widget.avatarId, key: avatarKey))
              : SizedBox(
                  height: 300,
                  width: 300,
                  child: O3D(
                      src:
                          'https://models.readyplayer.me/${widget.avatarId}.glb')),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Outfits',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.auth.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      default:
                        if (snapshot.hasData) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.monetization_on,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(
                                  width:
                                      4), // Adds a small space between the icon and text
                              Text(
                                '${data['points']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      return AssetDisplayWidget(
                        asset: assets[index],
                        index: index,
                        equipAsset: equipAsset,
                        auth: FirebaseAuth.instance,
                        onAssetClicked: () {
                          setState(() {
                            isCustomised = true;
                          });
                        },
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
