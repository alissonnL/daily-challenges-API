import 'package:postgres/postgres.dart';

import '../../domain/entities/friendship.dart';
import '../../domain/enums/friendship_status.dart';
import '../../domain/repositories/friendship_repository.dart';
import '../database/database_connection.dart';

class PostgresFriendshipRepository implements FriendshipRepository {
  PostgresFriendshipRepository();

  @override
  Future<void> create(Friendship friendship) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
        INSERT INTO friendships (
          requester_id,
          addressee_id,
          status,
          created_at
        ) VALUES (
          @requesterId,
          @addresseeId,
          @status,
          @createdAt
        )
      '''),
      parameters: {
        'requesterId': friendship.requesterId,
        'addresseeId': friendship.addresseeId,
        'status': friendship.status.name,
        'createdAt': friendship.createdAt,
      },
    );
  }

  @override
  Future<Friendship?> findBetweenUsers(int userA, int userB) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT id, requester_id, addressee_id, status, created_at
        FROM friendships
        WHERE 
          (requester_id = @userA AND addressee_id = @userB)
          OR
          (requester_id = @userB AND addressee_id = @userA)
        LIMIT 1
      '''),
      parameters: {
        'userA': userA,
        'userB': userB,
      },
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return _mapRow(row);
  }

  @override
  Future<List<Friendship>> findPendingByUser(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT
  f.id,
  f.requester_id,
  f.addressee_id,
  f.status,
  f.created_at,
  u.id AS user_id,
  u.name,
  u.email
FROM friendships f
JOIN users u ON
  (
    f.requester_id = @userId AND u.id = f.addressee_id
  )
  OR
  (
    f.addressee_id = @userId AND u.id = f.requester_id
  )
WHERE
  f.status = 'pending'

      '''),
      parameters: {'userId': userId},
    );

    return result.map(_mapRow).toList();
  }

  @override
  Future<void> updateStatus({
    required int id,
    required FriendshipStatus status,
  }) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
        UPDATE friendships
        SET status = @status
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
        'status': status.name,
      },
    );
  }

  @override
  Future<List<Friendship>> findFriendsOfUser(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT 
  f.id,
  f.requester_id,
  f.addressee_id,
  f.status,
  f.created_at,

  u.id     AS friend_id,
  u.name   AS friend_name,
  u.email  AS friend_email

FROM friendships f
JOIN users u
  ON u.id = CASE
      WHEN f.requester_id = @userId THEN f.addressee_id
      ELSE f.requester_id
    END

WHERE f.status = 'accepted'
  AND (f.requester_id = @userId OR f.addressee_id = @userId);
      '''),
      parameters: {'userId': userId},
    );

    return result.map(_mapRow).toList();
  }

  @override
  Future<Friendship?> findById(int id) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT id, requester_id, addressee_id, status, created_at
        FROM friendships
        WHERE id = @id
        LIMIT 1
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return _mapRowWhenById(row);
  }

  @override
  Future<void> sendRequest({
    required int requesterId,
    required int addresseeId,
  }) async {
    final connection = await DatabaseConnection.getConnection();
    await connection.execute(
      Sql.named('''
        INSERT INTO friendships (
          requester_id,
          addressee_id,
          status,
          created_at
        ) VALUES (
          @requesterId,
          @addresseeId,
          'pending',
          NOW()
        )
      '''),
      parameters: {
        'requesterId': requesterId,
        'addresseeId': addresseeId,
      },
    );
  }

  @override
  Future<bool> areFriends(int user, List<int> friends) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT * from friendships
		  WHERE status = 'accepted'
      AND (requester_id in (${friends.join(', ')}) or addressee_id in (${friends.join(', ')}))
		  AND (requester_id = @user or addressee_id = @user)
      '''),
      parameters: {'user': user},
    );

    return result.isNotEmpty;
  }

  @override
  Future<List<Friendship>> findFriendsByUser(int userId) async {
    final connection = await DatabaseConnection.getConnection();
    final result = await connection.execute(
      Sql.named('''
        SELECT id, requester_id, addressee_id, status, created_at
        FROM friendships
        WHERE status = 'accepted'
          AND (requester_id = @userId OR addressee_id = @userId)
      '''),
      parameters: {'userId': userId},
    );

    return result.map(_mapRow).toList();
  }

  Friendship _mapRow(ResultRow row) {
    final _friendship = Friendship(
      id: row[0] as int,
      requesterId: row[1] as int,
      addresseeId: row[2] as int,
      status: FriendshipStatus.values.firstWhere(
        (e) => e.name == row[3],
      ),
      createdAt: row[4] as DateTime,
    );
    _friendship.friendName = row[6].toString();
    _friendship.friendEmail = row[7].toString();

    return _friendship;
  }

  Friendship _mapRowWhenById(ResultRow row) {
    final _friendship = Friendship(
      id: row[0] as int,
      requesterId: row[1] as int,
      addresseeId: row[2] as int,
      status: FriendshipStatus.values.firstWhere(
        (e) => e.name == row[3],
      ),
      createdAt: row[4] as DateTime,
    );

    return _friendship;
  }
}
