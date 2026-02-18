import 'package:dart_frog/dart_frog.dart';

import '../../../lib/services/extra_challenge_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.patch) {
    return Response(statusCode: 405);
  }

  final extraId = int.tryParse(id);
  if (extraId == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid extra challenge id'},
    );
  }

  final userId = context.read<int>();
  final service = context.read<ExtraChallengeService>();

  try {
    await service.accept(extraId, userId);
    return Response(statusCode: 204);
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': e.toString()},
    );
  }
}
