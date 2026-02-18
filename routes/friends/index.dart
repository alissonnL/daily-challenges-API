import 'package:dart_frog/dart_frog.dart';

import '../../lib/services/friendship_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }

  final userId = context.read<int>();
  final service = context.read<FriendshipService>();

  final friends = await service.listFriends(userId);

  return Response.json(
    body: friends.map((f) {
      final friendId = f.requesterId == userId ? f.addresseeId : f.requesterId;

      return {
        'friendId': friendId,
        'friendName': f.friendName,
        'friendEmail': f.friendEmail,
        'since': f.createdAt.toIso8601String(),
      };
    }).toList(),
  );
}
