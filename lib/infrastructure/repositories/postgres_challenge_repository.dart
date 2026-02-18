import 'package:postgres/postgres.dart';

import '../../domain/entities/challenge.dart';
import '../../domain/repositories/challenge_repository.dart';
import '../database/database_connection.dart';
import '../models/challenge_model.dart';

class PostgresChallengeRepository implements ChallengeRepository {
  @override
  Future<List<Challenge>> findAllActive() async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT id, title, description, points, difficulty
        FROM challenges
        WHERE active = true
      '''),
    );

    return result
        .map((row) => ChallengeModel.fromRow(row.toColumnMap()).toEntity())
        .toList();
  }

  @override
  Future<Challenge?> findById(int id) async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT id, title, description, points, difficulty
        FROM challenges
        WHERE id = @id
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    return ChallengeModel.fromRow(
      result.first.toColumnMap(),
    ).toEntity();
  }
}
