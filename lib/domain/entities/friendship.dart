import '../enums/friendship_status.dart';

class Friendship {
  final int id;
  final int requesterId;
  final int addresseeId;
  final FriendshipStatus status;
  final DateTime createdAt;
  late String friendName;
  late String friendEmail;

  Friendship({
    required this.id,
    required this.requesterId,
    required this.addresseeId,
    required this.status,
    required this.createdAt,
  });
}
