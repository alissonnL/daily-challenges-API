import 'package:dart_frog/dart_frog.dart';
import '../../lib/middlewares/auth_middleware.dart';
import '../../lib/services/daily_challenge_service.dart';
import '../../lib/dtos/daily_challenge_dto.dart';

Handler onRequest = authMiddleware(
  (context) async {
    final userId = context.read<int>();
    final service = context.read<DailyChallengeService>();

    final challenge = await service.getDailyChallenge(userId);

    return Response.json(body: {
      'success': true,
      'data': DailyChallengeDto.fromEntity(challenge)
    });
  },
);
