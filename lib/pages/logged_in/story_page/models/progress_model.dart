class QuestProgressModel {
  final int distanceTravelled;
  final List<bool> questCompletionStatus;
  final List<int> questDistanceProgress;

  QuestProgressModel({
    required this.distanceTravelled,
    required this.questCompletionStatus,
    required this.questDistanceProgress,
  });

  // Getters
  int get getDistanceTravelled => distanceTravelled;
  List<bool> get getQuestCompletionStatus => questCompletionStatus;
  List<int> get getQuestDistanceProgress => questDistanceProgress;

  // Factory constructor for creating a new Quest instance from a Firestore document.
  factory QuestProgressModel.fromFirestore(Map<String, dynamic> doc) {
    return QuestProgressModel(
      distanceTravelled: doc['distanceTravelled'] ?? 0,
      questCompletionStatus: List<bool>.from(doc['questsCompleted'] ?? []),
      questDistanceProgress: List<int>.from(doc['questProgress'] ?? []),
    );
  }

  // Method to convert a Quest instance to a Map for Firestore.
  Map<String, dynamic> toFirestore() => {
        'distanceTravelled': distanceTravelled,
        'questsCompleted': questCompletionStatus,
        'questProgress': questDistanceProgress,
      };

  @override
  String toString() {
    return 'QuestProgressModel { distanceTravelled: $distanceTravelled, questCompletionStatus: $questCompletionStatus, questDistanceProgress: $questDistanceProgress }';
  }
}
