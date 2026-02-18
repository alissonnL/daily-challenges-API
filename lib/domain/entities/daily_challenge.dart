class DailyChallenge {
  final int id;
  final int userId;
  final int challengeId;
  final DateTime date;
  final bool completed;

  DailyChallenge({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.date,
    required this.completed,
  });
}
