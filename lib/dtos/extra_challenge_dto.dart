import '../domain/entities/extra_challenge.dart';

class ExtraChallengeDto {
  static Map<String, dynamic> fromEntity(ExtraChallenge extra) {
    return {
      'id': extra.id,
      'fromUserId': extra.fromUserId,
      'challengeId': extra.challengeId,
      'status': extra.status.name,
      'expiresAt': extra.expiresAt.toIso8601String(),
      'title': extra.title,
      'description': extra.description,
      'points': extra.points,
      'difficulty': extra.difficulty,
      'fromUserName': extra.fromUserName
    };
  }
}
