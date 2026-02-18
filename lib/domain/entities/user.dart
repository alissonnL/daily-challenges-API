class User {
  final int id;
  final String name;
  final String email;
  final String passwordHash;
  final bool avoidRepeatedChallenges;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.avoidRepeatedChallenges,
  });
}
