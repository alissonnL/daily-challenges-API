import '../domain/entities/daily_challenge.dart';
import 'challenge_dto.dart';
import '../domain/enums/challenge_difficulty.dart';

class DailyChallengeDto {
  static Map<String, dynamic> fromEntity(Map<String, dynamic> challenge) {
    return {
      "id": challenge['id'],
      "title": challenge['title'],
      "description": challenge['description'],
      "points": challenge['points'],
      "difficulty": ChallengeDifficulty.values
          .firstWhere((e) => e.toString() == challenge['difficulty'].toString())
          .name,
      "completed": challenge['completed']
    };
  }
}
