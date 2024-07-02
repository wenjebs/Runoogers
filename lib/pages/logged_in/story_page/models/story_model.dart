class Story {
  final String id;
  final String shortTitle;
  final String title;
  final String description;
  final String imageURL;
  final List<Map<String, dynamic>> quests;

  Story({
    required this.id,
    required this.shortTitle,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.quests,
  });
  // Getters
  String get getId => id;
  String get getTitle => title;
  String get getShortTitle => shortTitle;
  String get getDescription => description;
  String get getImageURL => imageURL;
  List<Map<String, dynamic>> get getQuests => quests;

  // Factory constructor for creating a new Story instance from a Firestore document.
  factory Story.fromFirestore(Map<String, dynamic> doc) {
    return Story(
      id: doc['id'] ?? '',
      shortTitle: doc['shortTitle'] ?? '',
      title: doc['title'] ?? '',
      description: doc['description'] ?? '',
      imageURL: doc['imageURL'] ?? '',
      quests: doc['quests'] != null
          ? List<Map<String, dynamic>>.from(
              doc['quests'].map((quest) => Map<String, dynamic>.from(quest)))
          : [],
    );
  }

  // Method to convert a Story instance to a Map for Firestore.
  Map<String, dynamic> toFirestore() => {
        'id': id,
        'shortTitle': shortTitle,
        'title': title,
        'description': description,
        'imageURL': imageURL,
        'quests': quests,
      };

  // Method to create a copy of an instance with optional new values.
  Story copyWith({
    String? id,
    String? shortTitle,
    String? title,
    String? description,
    String? imageURL,
    List<Map<String, dynamic>>? quests,
  }) {
    return Story(
      id: id ?? this.id,
      shortTitle: shortTitle ?? this.shortTitle,
      title: title ?? this.title,
      description: description ?? this.description,
      imageURL: imageURL ?? this.imageURL,
      quests: quests ?? this.quests,
    );
  }
}
