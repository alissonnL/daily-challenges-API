import 'package:desafios_diarios_api/infrastructure/database/database_connection.dart';
import 'package:postgres/postgres.dart';

import '../../domain/entities/extra_challenge.dart';
import '../../domain/repositories/extra_challenge_repository.dart';
import '../../domain/enums/extra_challenge_status.dart';

class PostgresExtraChallengeRepository implements ExtraChallengeRepository {
  @override
  Future<void> create(ExtraChallenge extra) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
        INSERT INTO extra_challenges (
          from_user_id,
          to_user_id,
          challenge_id,
          status,
          expires_at
        ) VALUES (
          @fromUserId,
          @toUserId,
          @challengeId,
          @status,
          @expiresAt
        )
      '''),
      parameters: {
        'fromUserId': extra.fromUserId,
        'toUserId': extra.toUserId,
        'challengeId': extra.challengeId,
        'status': extra.status.name,
        'expiresAt': extra.expiresAt,
      },
    );
  }

  @override
  Future<List<ExtraChallenge>> findPendingByUser(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT e.id, e.from_user_id, e.to_user_id, e.challenge_id, e.status, e.expires_at, e.created_at, c.title, c.description, c.points, c.difficulty, u.name
        FROM extra_challenges e
        inner join challenges c
        ON c.id = e.challenge_id
        inner join users u
        ON u.id = e.from_user_id
        WHERE to_user_id = @userId
          AND status = 'pending'
          AND expires_at > NOW()
      '''),
      parameters: {'userId': userId},
    );

    return result.map((row) {
      ExtraChallenge extra = ExtraChallenge(
          id: row[0] as int,
          fromUserId: row[1] as int,
          toUserId: row[2] as int,
          challengeId: row[3] as int,
          status: ExtraChallengeStatus.values.byName(row[4].toString()),
          expiresAt: DateTime.parse(row[5].toString()),
          createdAt: DateTime.parse(row[6].toString()));
      extra.title = row[7].toString();
      extra.description = row[8].toString();
      extra.points = row[9] as int;
      extra.difficulty = row[10].toString();
      extra.fromUserName = row[11].toString();

      return extra;
    }).toList();
  }

  @override
  Future<ExtraChallenge?> findById(int id) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT id, from_user_id, to_user_id, challenge_id, status, expires_at, created_at
        FROM extra_challenges
        WHERE id = @id
        LIMIT 1
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;
    return _mapRow(result.first);
  }

  @override
  Future<void> updateStatus({
    required int id,
    required ExtraChallengeStatus status,
  }) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
        UPDATE extra_challenges
        SET status = @status
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
        'status': status.name,
      },
    );
  }

  @override
  Future<void> deleteExpired() async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
        DELETE FROM extra_challenges
        WHERE expires_at < NOW()
      '''),
    );
  }

  ExtraChallenge _mapRow(List<dynamic> row) {
    return ExtraChallenge(
        id: row[0] as int,
        fromUserId: row[1] as int,
        toUserId: row[2] as int,
        challengeId: row[3] as int,
        status: ExtraChallengeStatus.values.byName(row[4].toString()),
        expiresAt: row[5] as DateTime,
        createdAt: row[6] as DateTime);
  }

  @override
  Future<void> expireOldChallenges() async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
        UPDATE extra_challenges
        SET status = 'expired'
        WHERE expires_at < NOW()
          AND status = 'pending'
      '''),
    );
  }

  @override
  Future<List<ExtraChallenge>> findCompletedByUser(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
      SELECT id, from_user_id, to_user_id, challenge_id, status, expires_at, created_at
      FROM extra_challenges
      WHERE to_user_id = @userId
        AND status = 'completed'
      ORDER BY expires_at DESC
    '''),
      parameters: {'userId': userId},
    );

    return result.map((row) {
      return ExtraChallenge(
          id: row[0] as int,
          fromUserId: row[1] as int,
          toUserId: row[2] as int,
          challengeId: row[3] as int,
          status: ExtraChallengeStatus.completed,
          expiresAt: row[5] as DateTime,
          createdAt: row[6] as DateTime);
    }).toList();
  }

  @override
  Future<List<ExtraChallenge>> findAccepted(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(Sql.named('''
        SELECT e.id, e.from_user_id, e.to_user_id, e.challenge_id, e.status, e.expires_at, e.created_at, c.title, c.description, c.points, c.difficulty, u.name
        FROM extra_challenges e
        inner join challenges c
        ON c.id = e.challenge_id
        inner join users u
        ON u.id = e.from_user_id
        WHERE e.to_user_id = @userId
        AND e.status = 'accepted'
        ORDER BY e.expires_at ASC
        '''), parameters: [userId]);

    return result.map(_mapRowWhenAccepted).toList();
  }

  ExtraChallenge _mapRowWhenAccepted(ResultRow row) {
    final ExtraChallenge extra = ExtraChallenge(
      id: row[0] as int,
      fromUserId: row[1] as int,
      toUserId: row[2] as int,
      challengeId: row[3] as int,
      status: ExtraChallengeStatus.accepted,
      expiresAt: row[5] as DateTime,
      createdAt: row[6] as DateTime,
    );

    extra.title = row[7].toString();
    extra.description = row[8].toString();
    extra.points = row[9] as int;
    extra.difficulty = row[10].toString();
    extra.fromUserName = row[11].toString();

    return extra;
  }
}
