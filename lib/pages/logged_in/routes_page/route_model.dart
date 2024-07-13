import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  String id;
  final String name;
  final String description;
  final String distance;
  final Set<LatLng> polylinePoints;
  final String imageUrl;

  RouteModel({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.polylinePoints,
    required this.imageUrl,
  });

  set setId(String id) => this.id = id;

  String get getId => id;
  String get getName => name;
  String get getDescription => description;
  String get getDistance => distance;
  Set<LatLng> get getPolylinePoints => polylinePoints;
  String get getImageUrl => imageUrl;

  factory RouteModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    var pointsData = (data!['polylinePoints'] as List)
        .map((pointData) =>
            LatLng(pointData['latitude'], pointData['longitude']))
        .toList()
        .toSet();

    return RouteModel(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      distance: data['distance'],
      polylinePoints: pointsData,
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'name': name,
        'description': description,
        'distance': distance,
        'polylinePoints': polylinePoints
            .map((point) =>
                {'latitude': point.latitude, 'longitude': point.longitude})
            .toList(),
        'imageUrl': imageUrl,
      };

  RouteModel copyWith({
    String? id,
    String? name,
    String? description,
    String? distance,
    Set<LatLng>? polylinePoints,
    String? imageUrl,
  }) {
    return RouteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      distance: distance ?? this.distance,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
