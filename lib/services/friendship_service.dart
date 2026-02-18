import '../domain/entities/friendship.dart';
import '../domain/enums/friendship_status.dart';
import '../domain/repositories/friendship_repository.dart';
import '../domain/repositories/user_repository.dart';
import 'notification_service.dart';
import '../infrastructure/repositories/postgres_notification_repository.dart';
import '../domain/enums/notification_type.dart';

class FriendshipService {
  final FriendshipRepository friendshipRepository;
  final UserRepository userRepository;
  final NotificationService notificationService =
      NotificationService(repository: PostgresNotificationRepository());

  FriendshipService({
    required this.friendshipRepository,
    required this.userRepository,
  });

  Future<void> sendRequest({
    required int fromUserId,
    required int toUserId,
  }) async {
    if (fromUserId == toUserId) {
      throw Exception('Cannot add yourself');
    }

    final fromUser = await userRepository.findById(fromUserId);
    final toUser = await userRepository.findById(toUserId);

    if (fromUser == null || toUser == null) {
      throw Exception('User not found');
    }

    final existing =
        await friendshipRepository.findBetweenUsers(fromUserId, toUserId);

    if (existing != null) {
      throw Exception('Friendship already exists');
    }

    await friendshipRepository.create(
      Friendship(
        id: 0,
        requesterId: fromUserId,
        addresseeId: toUserId,
        status: FriendshipStatus.pending,
        createdAt: DateTime.now(),
      ),
    );

    await notificationService.notify(
        userId: toUserId,
        type: NotificationType.friendshipRequest,
        title: "Solicitação de amizade",
        message: "Você recebeu um pedido de amizade.");
  }

  Future<void> accept(int friendshipId, int userId) async {
    final friendship = await friendshipRepository.findById(friendshipId);

    if (friendship == null) throw Exception('Not found');
    if (friendship.addresseeId != userId) throw Exception('Not allowed');
    if (friendship.status != FriendshipStatus.pending) {
      throw Exception('Already handled');
    }

    await friendshipRepository.updateStatus(
      id: friendshipId,
      status: FriendshipStatus.accepted,
    );

    await notificationService.notify(
        userId: friendship.requesterId,
        type: NotificationType.friendshipAccepted,
        title: "Amizade aceita",
        message: "Seu pedido de amizade foi aceito.");
  }

  Future<void> reject(int friendshipId, int userId) async {
    final friendship = await friendshipRepository.findById(friendshipId);

    if (friendship == null) throw Exception('Not found');
    if (friendship.addresseeId != userId) throw Exception('Not allowed');
    if (friendship.status != FriendshipStatus.pending) {
      throw Exception('Already handled');
    }

    await friendshipRepository.updateStatus(
      id: friendshipId,
      status: FriendshipStatus.rejected,
    );
  }

  Future<List<Friendship>> listFriends(int userId) {
    return friendshipRepository.findFriendsOfUser(userId);
  }

  Future<List<Friendship>> listPending(int userId) {
    return friendshipRepository.findPendingByUser(userId);
  }
}
