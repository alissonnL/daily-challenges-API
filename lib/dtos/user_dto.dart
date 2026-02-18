import '../domain/entities/user.dart';

class UserDto {
  static Map<String, dynamic> fromEntity(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'avoidRepeatedChallenges': user.avoidRepeatedChallenges,
    };
  }
}
