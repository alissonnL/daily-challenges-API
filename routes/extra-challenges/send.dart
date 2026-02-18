import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/extra_challenge_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }

  final data = jsonDecode(await context.request.body());

  final fromUserId = context.read<int>();
  final toUserIds =
      (data['toUserIds'] as List?)?.map((id) => id as int).toList();
  final challengeId = int.tryParse((data['challengeId'].toString()));

  if (fromUserId == null || toUserIds == null || challengeId == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Missing required fields'},
    );
  }

  final service = context.read<ExtraChallengeService>();

  try {
    await service.send(
      fromUserId: fromUserId,
      toUserIds: toUserIds,
      challengeId: challengeId,
    );
    return Response(statusCode: 201);
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': e.toString()},
    );
  }
}
