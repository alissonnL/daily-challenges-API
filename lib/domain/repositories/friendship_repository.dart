import '../entities/friendship.dart';
import '../enums/friendship_status.dart';

abstract class FriendshipRepository {
  Future<void> create(Friendship friendship);

  Future<Friendship?> findBetweenUsers(int userA, int userB);

  Future<List<Friendship>> findPendingByUser(int userId);

  Future<void> updateStatus({
    required int id,
    required FriendshipStatus status,
  });

  Future<List<Friendship>> findFriendsOfUser(int userId);

  Future<Friendship?> findById(int id);

  Future<void> sendRequest({
    required int requesterId,
    required int addresseeId,
  });

  Future<bool> areFriends(int user, List<int> friends);

  Future<List<Friendship>> findFriendsByUser(int userId);
}
