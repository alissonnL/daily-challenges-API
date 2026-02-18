import 'package:bcrypt/bcrypt.dart';

import '../domain/repositories/user_repository.dart';
import '../services/jwt_service.dart';
import '../domain/entities/user.dart';

class AuthService {
  final UserRepository userRepository;
  final JwtService jwtService;

  AuthService({
    required this.userRepository,
    required this.jwtService,
  });

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final user = await userRepository.findByEmail(email);

    if (user == null) {
      throw Exception('Invalid credentials');
    }

    if (user.passwordHash.isEmpty) {
      throw Exception('Invalid credentials hash');
    }

    final validPassword = BCrypt.checkpw(password, user.passwordHash);

    if (!validPassword) {
      throw Exception('Invalid credentials');
    }

    return jwtService.generateToken(
      user.id,
    );
  }

  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final existingUser = await userRepository.findByEmail(email);

    if (existingUser != null) {
      throw Exception('Email already in use');
    }

    final passwordHash = BCrypt.hashpw(
      password,
      BCrypt.gensalt(),
    );

    final user = await userRepository.create(
      name: name,
      email: email,
      passwordHash: passwordHash,
    );

    return jwtService.generateToken(
      user.id,
    );
  }
}
