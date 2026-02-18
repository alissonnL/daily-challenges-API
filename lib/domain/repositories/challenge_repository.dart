import '../entities/challenge.dart';

abstract class ChallengeRepository {
  Future<List<Challenge>> findAllActive();

  Future<Challenge?> findById(int id);
}
