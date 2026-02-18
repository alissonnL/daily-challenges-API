import '../domain/entities/notification.dart';

class NotificationDto {
  static Map<String, dynamic> fromEntity(Notification n) {
    return {
      'id': n.id,
      'userId': n.userId,
      'type': n.type.name,
      'title': n.title,
      'message': n.message,
      'read': n.read,
      'createdAt': n.createdAt.toIso8601String(),
    };
  }
}
