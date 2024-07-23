import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Run {
  String id;
  final String name;
  final String description;
  final String distance;
  final String time;
  final String date;
  final List<LatLng> polylinePoints;
  final String imageUrl;
  final double pace;

  Run({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.time,
    required this.date,
    required this.polylinePoints,
    required this.imageUrl,
    required this.pace,
  });

  set setId(String id) {
    this.id = id;
  }

  String get getId => id;
  String get getName => name;
  String get getDescription => description;
  String get getDistance => distance;
  String get getTime => time;
  String get getDate => date;
  List<LatLng> get getPolylinePoints => polylinePoints;
  String get getImageUrl => imageUrl;
  double get getPace => pace;

  factory Run.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    var pointsData = (data!['polylinePoints'] as List)
        .map((pointData) =>
            LatLng(pointData['latitude'], pointData['longitude']))
        .toList();
    var pace = data['pace'];
    double paceAsDouble = pace is int ? pace.toDouble() : pace;

    return Run(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      distance: data['distance'],
      time: data['time'],
      date: data['date'],
      polylinePoints: pointsData,
      imageUrl: data['imageUrl'],
      pace: paceAsDouble,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'name': name,
        'description': description,
        'distance': distance,
        'time': time,
        'date': date,
        'polylinePoints': polylinePoints
            .map((point) =>
                {'latitude': point.latitude, 'longitude': point.longitude})
            .toList(),
        'imageUrl': imageUrl,
        'pace': pace,
      };

  Run copyWith({
    String? id,
    String? name,
    String? description,
    String? distance,
    String? time,
    String? date,
    List<LatLng>? polylinePoints,
    String? imageUrl,
    double? pace,
  }) {
    return Run(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      date: date ?? this.date,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      imageUrl: imageUrl ?? this.imageUrl,
      pace: pace ?? this.pace,
    );
  }
}
