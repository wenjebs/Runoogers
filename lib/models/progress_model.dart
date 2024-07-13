class QuestProgressModel {
  final int currentQuest;
  final double distanceTravelled;
  final List<bool> questCompletionStatus;
  final List<double> questDistanceProgress;

  QuestProgressModel({
    required this.currentQuest,
    required this.distanceTravelled,
    required this.questCompletionStatus,
    required this.questDistanceProgress,
  });

  // Getters
  double get getDistanceTravelled => distanceTravelled;
  List<bool> get getQuestCompletionStatus => questCompletionStatus;
  List<double> get getQuestDistanceProgress => questDistanceProgress;

  // Factory constructor for creating a new Quest instance from a Firestore document.
  factory QuestProgressModel.fromFirestore(Map<String, dynamic> doc) {
    return QuestProgressModel(
      currentQuest: doc['currentQuest'] ?? 0,
      distanceTravelled: (doc['distanceTravelled'] as num?)?.toDouble() ?? 0.0,
      questCompletionStatus: List<bool>.from(doc['questsCompleted'] ?? []),
      questDistanceProgress: (doc['questProgress'] as List<dynamic>?)
              ?.map((item) => double.tryParse(item.toString()) ?? 0.0)
              .toList() ??
          [],
    );
  }

  // Method to convert a Quest instance to a Map for Firestore.
  Map<String, dynamic> toFirestore() => {
        'currentQuest': currentQuest,
        'distanceTravelled': distanceTravelled,
        'questsCompleted': questCompletionStatus,
        'questProgress': questDistanceProgress,
      };

  @override
  String toString() {
    return 'QuestProgressModel { currentQuest: $currentQuest ,distanceTravelled: $distanceTravelled, questCompletionStatus: $questCompletionStatus, questDistanceProgress: $questDistanceProgress }';
  }
}
