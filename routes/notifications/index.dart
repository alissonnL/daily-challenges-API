import 'package:dart_frog/dart_frog.dart';
import '../../lib/services/notification_service.dart';
import '../../lib/dtos/notification_dto.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: 405);
  }

  final userId = context.read<int>();
  final service = context.read<NotificationService>();

  final notifications = await service.list(userId);
  return Response.json(
    body: notifications.map((e) => NotificationDto.fromEntity(e)).toList(),
  );
}
