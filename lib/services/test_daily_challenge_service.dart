/*import '../domain/entities/user.dart';
import '../domain/entities/challenge.dart';
import '../domain/enums/challenge_difficulty.dart';
import 'daily_challenge_service.dart';
import 'fakes/fake_user_repository.dart';
import '../domain/repositories/fakes/fake_challenge_repository.dart';

Future<void> main() async {
  final userRepo = FakeUserRepository([
    User(
      id: 1,
      name: 'João',
      email: 'joao@email.com',
      avoidRepeatedChallenges: false,
    ),
  ]);

  final challengeRepo = FakeChallengeRepository([
    Challenge(
      id: 1,
      title: 'Leia 5 páginas',
      description: 'Leia um livro',
      points: 10,
      difficulty: ChallengeDifficulty.easy,
    ),
    Challenge(
      id: 2,
      title: 'Caminhe 10 minutos',
      description: 'Caminhada leve',
      points: 15,
      difficulty: ChallengeDifficulty.medium,
    ),
  ]);

  final service = DailyChallengeService(
    userRepository: userRepo,
    challengeRepository: challengeRepo,
  );

  final challenge = await service.getDailyChallenge(1);

  print('Desafio sorteado: ${challenge.title}');
}*/
