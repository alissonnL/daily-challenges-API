import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/friendship_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }

  final userId = context.read<int>();
  final service = context.read<FriendshipService>();

  final pending = await service.listPending(userId);

  return Response.json(
    body: pending
        .map((f) => {
              'id': f.id,
              'requesterId': f.requesterId,
              "userName": f.friendName,
              "userEmail": f.friendEmail,
              'createdAt': f.createdAt.toIso8601String(),
            })
        .toList(),
  );
}
