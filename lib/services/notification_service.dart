import '../domain/entities/notification.dart';
import '../domain/enums/notification_type.dart';
import '../infrastructure/repositories/postgres_notification_repository.dart';

class NotificationService {
  final PostgresNotificationRepository repository;

  NotificationService({
    required this.repository,
  });

  /// Criar notificação genérica
  Future<void> notify({
    required int userId,
    required NotificationType type,
    required String title,
    required String message,
  }) async {
    if (title.isEmpty || message.isEmpty) {
      throw ArgumentError('Title and message cannot be empty');
    }

    final notification = Notification(
      id: 0,
      userId: userId,
      type: type,
      title: title,
      message: message,
      read: false,
      createdAt: DateTime.now(),
    );

    await repository.create(notification);
  }

  /// Listar notificações do usuário
  Future<List<Notification>> list(int userId) {
    return repository.findByUser(userId);
  }

  /// Marcar uma notificação como lida
  Future<void> markAsRead(int notificationId, int userId) {
    return repository.markAsRead(notificationId, userId);
  }

  /// Marcar todas como lidas
  Future<void> markAllAsRead(int userId) {
    return repository.markAllAsRead(userId);
  }

  /// Contar não lidas (badge)
  Future<int> unreadCount(int userId) {
    return repository.countUnread(userId);
  }
}
