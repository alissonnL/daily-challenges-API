import 'dart:math';

import 'package:desafios_diarios_api/domain/repositories/extra_challenge_repository.dart';

import '../domain/entities/challenge.dart';
import '../domain/entities/daily_challenge.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/challenge_repository.dart';
import '../domain/repositories/daily_challenge_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../utils/date_utils.dart';

class DailyChallengeService {
  final UserRepository userRepository;
  final ChallengeRepository challengeRepository;
  final DailyChallengeRepository dailyChallengeRepository;

  DailyChallengeService({
    required this.userRepository,
    required this.challengeRepository,
    required this.dailyChallengeRepository,
  });

  Future<Map<String, dynamic>> getDailyChallenge(int userId) async {
    final today = DateUtils.dateOnly(DateTime.now());

    final user = await userRepository.findById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    final existingDaily = await dailyChallengeRepository.findByUserAndDate(
        userId: userId, date: today);

    if (existingDaily != null) {
      return _resolveChallenge(existingDaily);
    }

    var challenges = await challengeRepository.findAllActive();

    if (user.avoidRepeatedChallenges) {
      final completed =
          await dailyChallengeRepository.findCompletedByUser(userId);

      final completedIds = completed.map((c) => c.challengeId).toSet();

      challenges =
          challenges.where((c) => !completedIds.contains(c.id)).toList();
    }

    if (challenges.isEmpty) {
      throw Exception('No available challenges');
    }

    final selected = challenges[Random().nextInt(challenges.length)];

    final dailyChallenge = DailyChallenge(
      id: 0, // será definido pelo banco depois
      userId: userId,
      challengeId: selected.id,
      date: today,
      completed: false,
    );

    await dailyChallengeRepository.create(dailyChallenge);

    return {
      'id': selected.id,
      'title': selected.title,
      'description': selected.description,
      'difficulty': selected.difficulty,
      'points': selected.points,
      'completed': false
    };
  }

  Future<Map<String, dynamic>> _resolveChallenge(
      DailyChallenge dailyChallenge) async {
    final challenges = await challengeRepository.findAllActive();
    Challenge challenge = challenges.firstWhere(
      (c) => c.id == dailyChallenge.challengeId,
      orElse: () => throw Exception('Challenge not found'),
    );

    return {
      'id': challenge.id,
      'title': challenge.title,
      'description': challenge.description,
      'difficulty': challenge.difficulty,
      'points': challenge.points,
      'completed': dailyChallenge!.completed
    };
  }

  Future<void> completeTodayChallenge(int userId) async {
    final today = DateUtils.dateOnly(DateTime.now());

    final dailyChallenge = await dailyChallengeRepository.findByUserAndDate(
      userId: userId,
      date: today,
    );

    if (dailyChallenge == null) {
      throw Exception('Daily challenge not found');
    }

    if (dailyChallenge.completed) {
      throw Exception('Daily challenge already completed');
    }

    await dailyChallengeRepository.markAsCompleted(dailyChallenge.id);
  }
}
