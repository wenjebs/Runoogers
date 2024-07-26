import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AssetDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> asset;
  final int index;
  final Function(String, String) equipAsset;
  final FirebaseAuth auth;
  final Function onAssetClicked;

  const AssetDisplayWidget({
    super.key,
    required this.asset,
    required this.index,
    required this.equipAsset,
    required this.auth,
    required this.onAssetClicked,
  });

  @override
  _AssetDisplayWidgetState createState() => _AssetDisplayWidgetState();
}

class _AssetDisplayWidgetState extends State<AssetDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: () async {
              if (widget.asset['unlocked']) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Text("Loading..."),
                          ],
                        ),
                      ),
                    );
                  },
                );
                widget.onAssetClicked();
                widget.equipAsset(widget.asset['id'], widget.asset['type']);
                Navigator.of(context).pop();
              } else {
                _promptPurchase();
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  20.0), // Increased borderRadius for more rounded corners
              child: SizedBox(
                width: 100,
                height: 100,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(
                    widget.asset['iconUrl'],
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: widget.asset['unlocked']
                ? const Icon(Icons.check_circle, color: Colors.green)
                : Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary),
                        Text(
                          '${widget.asset['price']}',
                          style: TextStyle(
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.75),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _promptPurchase() async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.auth.currentUser!.uid);
    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists &&
        docSnapshot.data()!['points'] < widget.asset['price']) {
      // User does not have enough points, show an error dialog immediately
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Insufficient Points"),
            content:
                const Text("You do not have enough points to buy this asset."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Purchase Asset"),
            content: Text(
                "Do you want to buy this asset for \$${widget.asset['price']}?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Buy"),
                onPressed: () async {
                  await userDoc.update({
                    'points': FieldValue.increment(-500),
                  });
                  setState(() {
                    widget.asset['unlocked'] = true;
                  });
                  debugPrint("${widget.asset['id']}");

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.auth.currentUser!.uid)
                      .collection('assets')
                      .where('id', isEqualTo: widget.asset['id'])
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    if (querySnapshot.docs.isNotEmpty) {
                      var assetDoc = querySnapshot.docs.first;
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.auth.currentUser!.uid)
                          .collection('assets')
                          .doc(assetDoc.id)
                          .update({'unlocked': true})
                          .then(
                              (_) => debugPrint("Asset unlocked successfully"))
                          .catchError((error) =>
                              debugPrint("Error updating asset: $error"));
                      debugPrint("Asset found: ${assetDoc.id}");
                    } else {
                      debugPrint(
                          "No asset found with id: ${widget.asset['id']}");
                    }
                  }).catchError((error) {
                    debugPrint("Error fetching asset: $error");
                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
