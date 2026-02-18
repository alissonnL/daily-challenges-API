import '../domain/entities/challenge.dart';

class ChallengeDto {
  static Map<String, dynamic> fromEntity(Challenge challenge) {
    return {
      'id': challenge.id,
      'title': challenge.title,
      'description': challenge.description,
      'points': challenge.points,
      'difficulty': challenge.difficulty.name,
    };
  }
}
