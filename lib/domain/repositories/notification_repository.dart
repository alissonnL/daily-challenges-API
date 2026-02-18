import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<void> create(Notification notification);

  Future<List<Notification>> findByUser(int userId);

  Future<void> markAsRead(int notificationId, int userId);

  Future<void> markAllAsRead(int userId);

  Future<int> countUnread(int userId);
}
