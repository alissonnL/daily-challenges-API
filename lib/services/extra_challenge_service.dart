import '../domain/entities/extra_challenge.dart';
import '../domain/repositories/extra_challenge_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/repositories/challenge_repository.dart';
import '../domain/enums/extra_challenge_status.dart';
import '../infrastructure/repositories/postgres_friendship_repository.dart';
import '../services/notification_service.dart';
import '../infrastructure/repositories/postgres_notification_repository.dart';
import '../domain/enums/notification_type.dart';

class ExtraChallengeService {
  final ExtraChallengeRepository extraChallengeRepository;
  final UserRepository userRepository;
  final ChallengeRepository challengeRepository;
  final PostgresFriendshipRepository friendshipRepository;

  final NotificationService notificationService =
      NotificationService(repository: PostgresNotificationRepository());

  ExtraChallengeService({
    required this.extraChallengeRepository,
    required this.userRepository,
    required this.challengeRepository,
    required this.friendshipRepository,
  });

  Future<void> send({
    required int fromUserId,
    required List<int> toUserIds,
    required int challengeId,
  }) async {
    final fromUser = await userRepository.findById(fromUserId);
    if (fromUser == null) {
      throw Exception('User not found');
    }

    final challenge = await challengeRepository.findById(challengeId);
    if (challenge == null) {
      throw Exception('Challenge not found');
    }

    for (final toUserId in toUserIds) {
      if (fromUserId == toUserId) continue;

      final toUser = await userRepository.findById(toUserId);
      if (toUser == null) continue;

      final extraChallenge = ExtraChallenge(
          id: 0,
          fromUserId: fromUserId,
          toUserId: toUserId,
          challengeId: challengeId,
          status: ExtraChallengeStatus.pending,
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
          createdAt: DateTime.now());

      final areFriends =
          await friendshipRepository.areFriends(fromUserId, toUserIds);

      if (!areFriends) {
        throw Exception('You can only send challenges to friends');
      }

      await extraChallengeRepository.create(extraChallenge);

      toUserIds.forEach((id) {
        notificationService.notify(
            userId: id,
            title: "Novo desafio recebido",
            message: "Você recebeu um desafio extra!",
            type: NotificationType.extraChallengeReceived);
      });
    }
  }

  Future<List<ExtraChallenge>> getPending(int userId) async {
    await cleanupExpired();
    return extraChallengeRepository.findPendingByUser(userId);
  }

  Future<void> accept(int extraChallengeId, int userId) async {
    final extra = await extraChallengeRepository.findById(extraChallengeId);

    if (extra == null) throw Exception('Extra challenge not found');
    if (extra.toUserId != userId) throw Exception('Not allowed');
    if (extra.status != ExtraChallengeStatus.pending) {
      throw Exception('Challenge already handled');
    }
    if (extra.expiresAt.isBefore(DateTime.now())) {
      throw Exception('Challenge expired');
    }

    await extraChallengeRepository.updateStatus(
      id: extraChallengeId,
      status: ExtraChallengeStatus.accepted,
    );

    await notificationService.notify(
        userId: extra.fromUserId,
        title: "Desafio aceito",
        message: "Seu desafio extra foi aceito!",
        type: NotificationType.extraChallengeAccepted);
  }

  Future<void> reject(int extraChallengeId, int userId) async {
    final extra = await extraChallengeRepository.findById(extraChallengeId);

    if (extra == null) throw Exception('Extra challenge not found');
    if (extra.toUserId != userId) throw Exception('Not allowed');
    if (extra.status != ExtraChallengeStatus.pending) {
      throw Exception('Challenge already handled');
    }

    await extraChallengeRepository.updateStatus(
      id: extraChallengeId,
      status: ExtraChallengeStatus.rejected,
    );

    await notificationService.notify(
        userId: extra.fromUserId,
        title: "Desafio rejeitado",
        message: "Seu desafio extra foi rejeitado.",
        type: NotificationType.extraChallengeRejected);
  }

  Future<void> complete(int extraChallengeId, int userId) async {
    final extra = await extraChallengeRepository.findById(extraChallengeId);

    if (extra == null) {
      throw Exception('Extra challenge not found');
    }

    if (extra.toUserId != userId) {
      throw Exception('Not allowed');
    }

    if (extra.status != ExtraChallengeStatus.accepted) {
      throw Exception('Extra challenge not accepted');
    }

    if (extra.expiresAt.isBefore(DateTime.now())) {
      throw Exception('Extra challenge expired');
    }

    await extraChallengeRepository.updateStatus(
      id: extraChallengeId,
      status: ExtraChallengeStatus.completed,
    );
  }

  Future<List<ExtraChallenge>> getCompleted(int userId) async {
    return extraChallengeRepository.findCompletedByUser(userId);
  }

  Future<void> cleanupExpired() async {
    await extraChallengeRepository.expireOldChallenges();
  }

  Future<List<ExtraChallenge>> findAccepted(int userId) async {
    return extraChallengeRepository.findAccepted(userId);
  }
}
