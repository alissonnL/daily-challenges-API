import '../../domain/entities/notification.dart';
import '../../domain/enums/notification_type.dart';

class NotificationModel {
  final int id;
  final int userId;
  final NotificationType type;
  final String title;
  final String message;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromRow(Map<String, dynamic> row) {
    return NotificationModel(
      id: row['id'] as int,
      userId: row['user_id'] as int,
      type: NotificationType.values
          .firstWhere((n) => n.name == row['notification_type'].toString()),
      title: row['title'] as String,
      message: row['message'] as String,
      read: row['read'] as bool,
      createdAt: row['created_at'] as DateTime,
    );
  }

  Notification toEntity() {
    return Notification(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      read: read,
      createdAt: createdAt,
    );
  }
}
