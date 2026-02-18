import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

import '../../lib/domain/repositories/user_repository.dart';
import '../../lib/middlewares/auth_middleware.dart';
import '../../lib/dtos/user_dto.dart';

Handler onRequest = authMiddleware(
  (context) async {
    final userId = context.read<int>();
    final userRepository = context.read<UserRepository>();

    switch (context.request.method) {
      case HttpMethod.get:
        final user = await userRepository.findById(userId);

        if (user == null) {
          return Response.json(
            statusCode: 404,
            body: {'message': 'User not found'},
          );
        }

        return Response.json(
          body: {'success': true, 'data': UserDto.fromEntity(user)},
        );

      case HttpMethod.patch:
        final body = await context.request.body();
        final data = jsonDecode(body);

        final avoidRepeatedChallenges = data['avoidRepeatedChallenges'];

        if (avoidRepeatedChallenges == null ||
            avoidRepeatedChallenges is! bool) {
          return Response.json(
            statusCode: 400,
            body: {
              'message': 'avoidRepeatedChallenges must be a boolean',
            },
          );
        }

        await userRepository.updateAvoidRepeatedChallenges(
          userId: userId,
          avoidRepeatedChallenges: avoidRepeatedChallenges,
        );

        return Response(statusCode: 204);

      default:
        return Response(statusCode: 405);
    }
  },
);
