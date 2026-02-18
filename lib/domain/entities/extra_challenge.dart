import '../enums/extra_challenge_status.dart';

class ExtraChallenge {
  final int id;
  final int fromUserId;
  final int toUserId;
  final int challengeId;
  final ExtraChallengeStatus status;
  final DateTime expiresAt;
  final DateTime createdAt;

  late String? title;
  late String? description;
  late int? points;
  late String? difficulty;
  late String? fromUserName;

  ExtraChallenge({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.challengeId,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
  });
}
