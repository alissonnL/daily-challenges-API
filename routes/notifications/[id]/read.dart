import 'package:dart_frog/dart_frog.dart';
import '../../../lib/services/notification_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.patch) {
    return Response(statusCode: 405);
  }

  final notificationId = int.tryParse(id);
  final userId = context.read<int>();

  if (notificationId == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid notification id'},
    );
  }

  final service = context.read<NotificationService>();

  await service.markAsRead(notificationId, userId);

  return Response(statusCode: 204);
}
