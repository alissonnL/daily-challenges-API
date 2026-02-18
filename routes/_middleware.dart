import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:dart_frog_request_logger/dart_frog_request_logger.dart';

import '../lib/domain/repositories/user_repository.dart';
import '../lib/domain/repositories/challenge_repository.dart';
import '../lib/domain/repositories/daily_challenge_repository.dart';
import '../lib/domain/repositories/extra_challenge_repository.dart';
import '../lib/domain/repositories/friendship_repository.dart';
import '../lib/domain/repositories/notification_repository.dart';

import '../lib/infrastructure/repositories/postgres_user_repository.dart';
import '../lib/infrastructure/repositories/postgres_challenge_repository.dart';
import '../lib/infrastructure/repositories/postgres_daily_challenge_repository.dart';
import '../lib/infrastructure/repositories/postgres_extra_challenge_repository.dart';
import '../lib/infrastructure/repositories/postgres_friendship_repository.dart';
import '../lib/infrastructure/repositories/postgres_notification_repository.dart';

import '../lib/services/jwt_service.dart';
import '../lib/services/auth_service.dart';
import '../lib/services/daily_challenge_service.dart';
import '../lib/services/extra_challenge_service.dart';
import '../lib/services/friendship_service.dart';
import '../lib/services/notification_service.dart';

final env = DotEnv()..load();

Handler middleware(Handler handler) {
  final loggedHandler = requestLogger()(handler);
  print(' Root middleware loaded');

  return (context) async {
    // Repositories
    final userRepository = PostgresUserRepository();
    final challengeRepository = PostgresChallengeRepository();
    final dailyChallengeRepository = PostgresDailyChallengeRepository();
    final extraChallengeRepository = PostgresExtraChallengeRepository();
    final friendshipRepository = PostgresFriendshipRepository();
    final notificationRepository = PostgresNotificationRepository();

    // JWT
    final jwtService = JwtService(
      secret: env['JWT_SECRET']!,
      expiration: const Duration(hours: 24),
    );

    // Services
    final authService = AuthService(
      userRepository: userRepository,
      jwtService: jwtService,
    );

    final dailyChallengeService = DailyChallengeService(
      userRepository: userRepository,
      challengeRepository: challengeRepository,
      dailyChallengeRepository: dailyChallengeRepository,
    );

    final extraChallengeService = ExtraChallengeService(
        extraChallengeRepository: extraChallengeRepository,
        userRepository: userRepository,
        challengeRepository: challengeRepository,
        friendshipRepository: friendshipRepository);

    final friendshipService = FriendshipService(
      friendshipRepository: friendshipRepository,
      userRepository: userRepository,
    );

    final notificationService =
        NotificationService(repository: notificationRepository);

    // Injeta dependências no contexto
    var updatedContext = context
        .provide<UserRepository>(() => userRepository)
        .provide<ChallengeRepository>(() => challengeRepository)
        .provide<DailyChallengeRepository>(() => dailyChallengeRepository)
        .provide<ExtraChallengeRepository>(() => extraChallengeRepository)
        .provide<FriendshipRepository>(() => friendshipRepository)
        .provide<NotificationRepository>(() => notificationRepository)
        .provide<JwtService>(() => jwtService)
        .provide<AuthService>(() => authService)
        .provide<DailyChallengeService>(() => dailyChallengeService)
        .provide<ExtraChallengeService>(() => extraChallengeService)
        .provide<FriendshipService>(() => friendshipService)
        .provide<NotificationService>(() => notificationService);

    // AUTH MIDDLEWARE (GLOBAL)
    final path = context.request.uri.path;

    // Rotas públicas
    if (!path.startsWith('/auth')) {
      final authHeader = context.request.headers['authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.json(
          statusCode: 401,
          body: {'message': 'Missing Authorization header'},
        );
      }

      final token = authHeader.replaceFirst('Bearer ', '');

      try {
        final userId = jwtService.verifyAndExtractUserId(token);

        // Injeta userId no contexto
        updatedContext = updatedContext.provide<int>(() => userId);
      } catch (_) {
        return Response.json(
          statusCode: 401,
          body: {'message': 'Invalid or expired token'},
        );
      }
    }

    return loggedHandler(updatedContext);
    // return handler(updatedContext); anterior ao request
  };
}
