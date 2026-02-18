import '../enums/notification_type.dart';

class Notification {
  final int id;
  final int userId;
  final NotificationType type;
  final String title;
  final String message;
  final bool read;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.message,
    required this.read,
    required this.createdAt,
  });
}
