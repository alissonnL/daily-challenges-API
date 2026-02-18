import '../enums/challenge_difficulty.dart';

class Challenge {
  final int id;
  final String title;
  final String description;
  final int points;
  final ChallengeDifficulty difficulty;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'difficulty': difficulty.toString().split('.').last,
    };
  }
}
