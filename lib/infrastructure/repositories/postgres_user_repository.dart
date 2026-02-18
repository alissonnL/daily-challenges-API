import 'package:postgres/postgres.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../database/database_connection.dart';
import '../models/user_model.dart';

class PostgresUserRepository implements UserRepository {
  @override
  Future<User?> findById(int id) async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT id, name, email, password_hash, avoid_repeated_challenges
        FROM users
        WHERE id = @id
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final row = result.first.toColumnMap();
    return UserModel.fromRow(row).toEntity();
  }

  @override
  Future<User?> findByEmail(String email) async {
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT id, name, email, password_hash, avoid_repeated_challenges
        FROM users
        WHERE email = @email
      '''),
      parameters: {'email': email},
    );

    if (result.isEmpty) return null;

    final row = result.first.toColumnMap();
    return UserModel.fromRow(row).toEntity();
  }

  @override
  Future<User> create({
    required String name,
    required String email,
    required String passwordHash,
  }) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
      INSERT INTO users (
        name,
        email,
        password_hash,
        avoid_repeated_challenges
      ) VALUES (
        @name,
        @email,
        @passwordHash,
        false
      )
      RETURNING id, name, email, password_hash, avoid_repeated_challenges
    '''),
      parameters: {
        'name': name,
        'email': email,
        'passwordHash': passwordHash,
      },
    );

    final row = result.first;

    return User(
      id: row[0] as int,
      name: row[1] as String,
      email: row[2] as String,
      passwordHash: row[3] as String,
      avoidRepeatedChallenges: row[4] as bool,
    );
  }

  @override
  Future<void> updateAvoidRepeatedChallenges({
    required int userId,
    required bool avoidRepeatedChallenges,
  }) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
      UPDATE users
      SET avoid_repeated_challenges = @avoid
      WHERE id = @userId
    '''),
      parameters: {
        'avoid': avoidRepeatedChallenges,
        'userId': userId,
      },
    );
  }
}
