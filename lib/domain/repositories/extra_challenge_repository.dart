import '../entities/extra_challenge.dart';
import '../enums/extra_challenge_status.dart';

abstract class ExtraChallengeRepository {
  Future<void> create(ExtraChallenge extraChallenge);

  Future<List<ExtraChallenge>> findPendingByUser(int userId);

  Future<ExtraChallenge?> findById(int id);

  Future<void> updateStatus({
    required int id,
    required ExtraChallengeStatus status,
  });

  Future<void> deleteExpired();

  Future<void> expireOldChallenges();

  Future<List<ExtraChallenge>> findCompletedByUser(int userId);

  Future<List<ExtraChallenge>> findAccepted(int userId);
}
