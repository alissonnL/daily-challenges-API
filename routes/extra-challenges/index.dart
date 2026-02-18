import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/extra_challenge_service.dart';
import '../../lib/dtos/extra_challenge_dto.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }

  final userId = context.read<int>();

  if (userId == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'userId is required'},
    );
  }

  final service = context.read<ExtraChallengeService>();
  final accepteds = await service.findAccepted(userId);

  return Response.json(
      body: accepteds.map(ExtraChallengeDto.fromEntity).toList());
}
