import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/daily_challenge_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.patch) {
    return Response(statusCode: 405);
  }

  final userId = context.read<int>();

  if (userId == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'userId is required'},
    );
  }

  final service = context.read<DailyChallengeService>();

  try {
    await service.completeTodayChallenge(userId);
    return Response(statusCode: 204);
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': e.toString()},
    );
  }
}
