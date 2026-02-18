import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> findById(int id);
  Future<User?> findByEmail(String email);

  Future<User> create({
    required String name,
    required String email,
    required String passwordHash,
  });

  Future<void> updateAvoidRepeatedChallenges({
    required int userId,
    required bool avoidRepeatedChallenges,
  });
}
