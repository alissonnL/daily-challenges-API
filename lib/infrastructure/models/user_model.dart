import '../../domain/entities/user.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String passwordHash;
  final bool avoidRepeatedChallenges;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.avoidRepeatedChallenges,
  });

  factory UserModel.fromRow(Map<String, dynamic> row) {
    return UserModel(
      id: row['id'] as int,
      name: row['name'] as String,
      email: row['email'] as String,
      passwordHash: row['password_hash'] as String,
      avoidRepeatedChallenges: row['avoid_repeated_challenges'] as bool,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      passwordHash: passwordHash,
      avoidRepeatedChallenges: avoidRepeatedChallenges,
    );
  }
}
