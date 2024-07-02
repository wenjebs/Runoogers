import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String id;
  final String shortTitle;
  final String title;
  final String description;
  final String imageURL;

  Story({
    required this.id,
    required this.shortTitle,
    required this.title,
    required this.description,
    required this.imageURL,
  });
  // Getters
  String get getId => id;
  String get getTitle => title;
  String get getDescription => description;
  String get getImageURL => imageURL;

  // Factory constructor for creating a new Story instance from a Firestore document.
  factory Story.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Story(
      id: data?['id'] ?? '',
      shortTitle: data?['shortTitle'] ?? '',
      title: data?['title'] ?? '',
      description: data?['description'] ?? '',
      imageURL: data?['imageURL'] ?? '',
    );
  }

  // Method to convert a Story instance to a Map for Firestore.
  Map<String, dynamic> toFirestore() => {
        'id': id,
        'shortTitle': shortTitle,
        'title': title,
        'description': description,
        'imageURL': imageURL,
      };

  // Method to create a copy of an instance with optional new values.
  Story copyWith({
    String? id,
    String? shortTitle,
    String? title,
    String? description,
    String? imageURL,
  }) {
    return Story(
      id: id ?? this.id,
      shortTitle: shortTitle ?? this.shortTitle,
      title: title ?? this.title,
      description: description ?? this.description,
      imageURL: imageURL ?? this.imageURL,
    );
  }
}
