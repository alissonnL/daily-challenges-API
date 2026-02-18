import 'package:postgres/postgres.dart';

import '../../domain/entities/daily_challenge.dart';
import '../../domain/repositories/daily_challenge_repository.dart';
import '../../utils/date_utils.dart';
import '../database/database_connection.dart';
import '../models/daily_challenge_model.dart';

class PostgresDailyChallengeRepository implements DailyChallengeRepository {
  @override
  Future<DailyChallenge?> findByUserAndDate({
    required int userId,
    required DateTime date,
  }) async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT id, user_id, challenge_id, date, completed
        FROM daily_challenges
        WHERE user_id = @userId
          AND date = @date
        LIMIT 1
      '''),
      parameters: {
        'userId': userId,
        'date': DateUtils.dateOnly(date),
      },
    );

    if (result.isEmpty) return null;

    return DailyChallengeModel.fromRow(
      result.first.toColumnMap(),
    ).toEntity();
  }

  @override
  Future<DailyChallenge> create(DailyChallenge dailyChallenge) async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        INSERT INTO daily_challenges (
          user_id, challenge_id, date, completed
        ) VALUES (
          @userId, @challengeId, @date, @completed
        )
        RETURNING id
      '''),
      parameters: {
        'userId': dailyChallenge.userId,
        'challengeId': dailyChallenge.challengeId,
        'date': DateUtils.dateOnly(dailyChallenge.date),
        'completed': dailyChallenge.completed,
      },
    );

    return DailyChallenge(
      id: result.first[0] as int,
      userId: dailyChallenge.userId,
      challengeId: dailyChallenge.challengeId,
      date: dailyChallenge.date,
      completed: dailyChallenge.completed,
    );
  }

  @override
  Future<void> markAsCompleted(int dailyChallengeId) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        UPDATE daily_challenges
        SET completed = true
        WHERE id = @id
      '''),
      parameters: {'id': dailyChallengeId},
    );
  }

  @override
  Future<List<DailyChallenge>> findCompletedByUser(int userId) async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT id, user_id, challenge_id, date, completed
        FROM daily_challenges
        WHERE user_id = @userId
          AND completed = true
      '''),
      parameters: {'userId': userId},
    );

    return result
        .map((row) => DailyChallengeModel.fromRow(row.toColumnMap()).toEntity())
        .toList();
  }
}
