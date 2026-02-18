import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/extra_challenge_service.dart';
import '../../lib/dtos/extra_challenge_dto.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }

  final userId = context.read<int>();
  final service = context.read<ExtraChallengeService>();

  try {
    // Cleanup automático
    await service.cleanupExpired();

    final extras = await service.getPending(userId);

    return Response.json(body: {
      'success': true,
      'data': extras.map((e) => ExtraChallengeDto.fromEntity(e)).toList(),
    });
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': e.toString()},
    );
  }
}
