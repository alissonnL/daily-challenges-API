import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../database/database_connection.dart';
import 'package:postgres/postgres.dart' hide Notification;
import '../models/notification_model.dart';

class PostgresNotificationRepository implements NotificationRepository {
  @override
  Future<void> create(Notification notification) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
        Sql.named(
            '''INSERT INTO notifications (user_id, notification_type, title, message, read, created_at)
        VALUES (@user_id, @type, @title, @message, @read, @created_at)'''),
        parameters: {
          'user_id': notification.userId,
          'type': notification.type.name,
          'title': notification.title,
          'message': notification.message,
          'read': notification.read,
          'created_at': notification.createdAt
        });
  }

  @override
  Future<List<Notification>> findByUser(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''SELECT * FROM notifications
        WHERE user_id = @userId
        ORDER BY created_at DESC'''),
      parameters: {'userId': userId},
    );

    return result
        .map((row) => NotificationModel.fromRow(row.toColumnMap()).toEntity())
        .toList();
  }

  Future<void> markAsRead(int notificationId, int userId) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(Sql.named('''UPDATE notifications
        SET read = true
        WHERE id = @notificationId AND user_id = @userId'''),
        parameters: {'notificationId': notificationId, 'userId': userId});
  }

  Future<void> markAllAsRead(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(Sql.named('''UPDATE notifications
        SET read = true
        WHERE user_id = @userId'''), parameters: {'userId': userId});
  }

  Future<int> countUnread(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
        Sql.named('''SELECT COUNT(*) FROM notifications
        WHERE user_id = @userId AND read = false'''),
        parameters: {'userId': userId});

    return result.first[0] as int;
  }
}
