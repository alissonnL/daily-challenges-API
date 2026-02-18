import '../entities/daily_challenge.dart';

abstract class DailyChallengeRepository {
  Future<DailyChallenge?> findByUserAndDate({
    required int userId,
    required DateTime date,
  });

  Future<DailyChallenge> create(DailyChallenge dailyChallenge);

  Future<void> markAsCompleted(int dailyChallengeId);

  Future<List<DailyChallenge>> findCompletedByUser(int userId);
}
