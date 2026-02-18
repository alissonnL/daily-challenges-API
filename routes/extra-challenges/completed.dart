import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/extra_challenge_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }

  final userId = context.read<int>();
  final service = context.read<ExtraChallengeService>();

  try {
    final extras = await service.getCompleted(userId);

    return Response.json(
      body: extras
          .map((e) => {
                'id': e.id,
                'fromUserId': e.fromUserId,
                'challengeId': e.challengeId,
                'expiresAt': e.expiresAt.toIso8601String(),
              })
          .toList(),
    );
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': e.toString()},
    );
  }
}
