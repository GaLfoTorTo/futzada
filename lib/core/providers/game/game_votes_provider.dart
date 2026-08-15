import 'package:flutter_riverpod/flutter_riverpod.dart';

//ESTADO - GAME VOTES
class GameVotesState {
  final int votesGameCount;
  final int votesMVPCount;
  final Map<String, double> votesGame;
  final Map<String, int> votesMVP;

  const GameVotesState({
    this.votesGameCount = 25,
    this.votesMVPCount = 25,
    this.votesGame = const {},
    this.votesMVP = const {},
  });

  GameVotesState copyWith({
    int? votesGameCount,
    int? votesMVPCount,
    Map<String, double>? votesGame,
    Map<String, int>? votesMVP,
  }) => GameVotesState(
    votesGameCount: votesGameCount ?? this.votesGameCount,
    votesMVPCount: votesMVPCount ?? this.votesMVPCount,
    votesGame: votesGame ?? this.votesGame,
    votesMVP: votesMVP ?? this.votesMVP,
  );
}

//NOTIFICADOR - GAME VOTES
class GameVotesNotifier extends Notifier<GameVotesState> {
  @override
  GameVotesState build() => const GameVotesState();

  //FUNÇÃO DE INICIALIZAÇÃO DE VOTOS
  void initVotes() {
    state = state.copyWith(
      votesGame: {'team1': 70, 'draw': 20, 'team2': 10},
      votesMVP: {},
    );
  }
}

//PROVIDER - GAME VOTES
final gameVotesProvider = NotifierProvider<GameVotesNotifier, GameVotesState>(GameVotesNotifier.new);
