import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtService {
  final String secret;
  final Duration expiration;

  JwtService({
    required this.secret,
    required this.expiration,
  });

  String generateToken(int userId) {
    final jwt = JWT(
      {
        'userId': userId,
      },
      issuer: 'desafios-diarios-api',
    );

    return jwt.sign(
      SecretKey(secret),
      expiresIn: expiration,
    );
  }

  int verifyAndExtractUserId(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(secret),
    );

    return jwt.payload['userId'] as int;
  }
}
