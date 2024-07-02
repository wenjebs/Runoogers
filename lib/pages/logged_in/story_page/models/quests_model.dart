class Quest {
  final String id;
  final String title;
  final String description;
  final double distance;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.distance,
  });

  // Getters
  String get getId => id;
  String get getTitle => title;
  String get getDescription => description;
  double get getDistance => distance;

  // Factory constructor for creating a new Quest instance from a Firestore document.
  factory Quest.fromFirestore(Map<String, dynamic> doc) {
    return Quest(
      id: doc['id'] ?? '',
      title: doc['title'] ?? '',
      description: doc['description'] ?? '',
      distance: doc['distance'] != null ? doc['distance'].toDouble() : 0.0,
    );
  }

  // Method to convert a Quest instance to a Map for Firestore.
  Map<String, dynamic> toFirestore() => {
        'id': id,
        'title': title,
        'description': description,
        'distance': distance,
      };

  // Method to create a copy of an instance with optional new values.
  Quest copyWith({
    String? id,
    String? title,
    String? description,
    double? distance,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      distance: distance ?? this.distance,
    );
  }
}
