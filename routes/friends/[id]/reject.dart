import 'package:dart_frog/dart_frog.dart';

import '../../../lib/services/friendship_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.patch) {
    return Response(statusCode: 405);
  }

  final friendshipId = int.tryParse(id);
  final userId = context.read<int>();

  if (friendshipId == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid id'},
    );
  }

  final service = context.read<FriendshipService>();

  try {
    await service.reject(friendshipId, userId);
    return Response(statusCode: 204);
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': e.toString()},
    );
  }
}
