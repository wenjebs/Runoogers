import 'package:cloud_firestore/cloud_firestore.dart';

class Run {
  String id;
  final String name;
  final String description;
  final String distance;
  final String time;
  final String date;

  Run(
      {required this.id,
      required this.name,
      required this.description,
      required this.distance,
      required this.time,
      required this.date});

  set setId(String id) {
    this.id = id;
  }

  factory Run.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Run(
      id: data!['id'],
      name: data['name'],
      description: data['description'],
      distance: data['distance'],
      time: data['time'],
      date: data['date'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'name': name,
        'description': description,
        'distance': distance,
        'time': time,
        'date': date,
      };

  Run copyWith({
    String? id,
    String? name,
    String? description,
    String? distance,
    String? time,
    String? date,
  }) {
    return Run(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }
}
