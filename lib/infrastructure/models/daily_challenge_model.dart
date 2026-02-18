import '../../domain/entities/daily_challenge.dart';

class DailyChallengeModel {
  final int id;
  final int userId;
  final int challengeId;
  final DateTime date;
  final bool completed;

  DailyChallengeModel({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.date,
    required this.completed,
  });

  factory DailyChallengeModel.fromRow(Map<String, dynamic> row) {
    return DailyChallengeModel(
      id: row['id'] as int,
      userId: row['user_id'] as int,
      challengeId: row['challenge_id'] as int,
      date: row['date'] as DateTime,
      completed: row['completed'] as bool,
    );
  }

  DailyChallenge toEntity() {
    return DailyChallenge(
      id: id,
      userId: userId,
      challengeId: challengeId,
      date: date,
      completed: completed,
    );
  }
}
