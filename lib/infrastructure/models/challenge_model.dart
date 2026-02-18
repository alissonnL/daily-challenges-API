import '../../domain/entities/challenge.dart';
import '../../domain/enums/challenge_difficulty.dart';

class ChallengeModel {
  final int id;
  final String title;
  final String description;
  final int points;
  final String difficulty;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.difficulty,
  });

  factory ChallengeModel.fromRow(Map<String, dynamic> row) {
    return ChallengeModel(
      id: row['id'] as int,
      title: row['title'] as String,
      description: row['description'] as String,
      points: row['points'] as int,
      difficulty: row['difficulty'] as String,
    );
  }

  Challenge toEntity() {
    return Challenge(
      id: id,
      title: title,
      description: description,
      points: points,
      difficulty: ChallengeDifficulty.values.byName(difficulty),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'difficulty': difficulty,
    };
  }
}
