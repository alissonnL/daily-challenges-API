import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/friendship_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }

  final data = jsonDecode(await context.request.body());
  final toUserId = int.tryParse(data['toUserId'].toString());
  final fromUserId = context.read<int>();

  if (toUserId == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid user id'},
    );
  }

  final service = context.read<FriendshipService>();

  try {
    await service.sendRequest(
      fromUserId: fromUserId,
      toUserId: toUserId,
    );
    return Response(statusCode: 201);
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': e.toString()},
    );
  }
}
