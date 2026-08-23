import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/game_config_model.dart';
import 'package:esportly/data/models/game_model.dart';
import 'package:esportly/data/models/result_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/providers/game/game_match_provider.dart';
import 'package:esportly/core/providers/game/game_schedule_provider.dart';
import 'package:esportly/core/providers/game/game_votes_provider.dart';

//ESTADO - GAME SESSION
class GameSessionState {
  final EventModel? event;
  final GameModel? currentGame;
  final GameConfigModel? currentGameConfig;

  const GameSessionState({
    this.event,
    this.currentGame,
    this.currentGameConfig,
  });

  GameSessionState copyWith({
    EventModel? event,
    GameModel? currentGame,
    GameConfigModel? currentGameConfig,
  }) => GameSessionState(
    event: event ?? this.event,
    currentGame: currentGame ?? this.currentGame,
    currentGameConfig: currentGameConfig ?? this.currentGameConfig,
  );
}

//NOTIFICADOR - GAME SESSION
class GameSessionNotifier extends Notifier<GameSessionState> {
  @override
  GameSessionState build() => const GameSessionState();

  //FUNÇÃO DE DEFINIÇÃO DE EVENTO DA PARTIDA
  void setEvent(EventModel event) {
    state = state.copyWith(
      event: event,
      currentGameConfig: event.gameConfig,
    );
  }

  //FUNÇÃO DE DEFINIÇÃO DE PARTIDA ATUAL
  void setCurrentGame(GameModel game) {
    state = state.copyWith(currentGame: game);
    ref.read(gameMatchProvider.notifier).setTeamsFromGame(game);
  }

  //FUNÇÃO DE DEFINIÇÃO DE CONFIGURAÇÕES DE PARTIDA
  void setGameConfig(GameConfigModel config) {
    state = state.copyWith(currentGameConfig: config);
  }

  //FUNÇÃO DE APLICAÇÃO DE CONFIGURAÇÕES DE PARTIDA
  void applyGameConfig({
    required String categoryText,
    required String durationText,
    required String playersPerTeamText,
    required String hasTwoHalvesText,
    required String hasExtraTimeText,
    required String hasPenaltyText,
    required String hasGoalLimitText,
    required String hasRefereerText,
    required String extraTimeText,
    required String goalLimitText,
    required String teamAName,
    required String teamAEmblem,
    required String teamBName,
    required String teamBEmblem,
    required int startTimeMinutes,
    UserModel? refereer,
  }) {
    if (state.currentGameConfig == null || state.currentGame == null || state.event == null) return;

    final newConfig = GameConfigModel(
      id: state.currentGameConfig!.id,
      eventId: state.event!.id!,
      category: categoryText,
      duration: int.tryParse(durationText) ?? state.currentGameConfig!.duration,
      playersPerTeam: int.tryParse(playersPerTeamText) ?? state.currentGameConfig!.playersPerTeam,
      config: {
        'hasTwoHalves': bool.tryParse(hasTwoHalvesText) ?? false,
        'hasExtraTime': bool.tryParse(hasExtraTimeText) ?? false,
        'hasPenalty': bool.tryParse(hasPenaltyText) ?? false,
        'hasGoalLimit': bool.tryParse(hasGoalLimitText) ?? false,
        'hasRefereer': bool.tryParse(hasRefereerText) ?? false,
        'extraTime': bool.tryParse(hasExtraTimeText) == true ? int.tryParse(extraTimeText) : null,
        'goalLimit': bool.tryParse(hasGoalLimitText) == true ? int.tryParse(goalLimitText) : null,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final newTeamA = ref.read(gameMatchProvider).teamA.copyWith(name: teamAName, emblem: teamAEmblem);
    final newTeamB = ref.read(gameMatchProvider).teamB.copyWith(name: teamBName, emblem: teamBEmblem);

    final totalDuration = (newConfig.config?['hasTwoHalves'] == true)
        ? (newConfig.duration ?? 0) * 2
        : (newConfig.duration ?? 0);

    final updatedGame = state.currentGame!.copyWith(
      refereeId: refereer?.id,
      duration: newConfig.duration,
      startTime: state.currentGame!.startTime ??
          DateTime.now().add(Duration(minutes: startTimeMinutes)),
      endTime: (state.currentGame!.startTime ?? DateTime.now())
          .add(Duration(minutes: totalDuration)),
      result: ResultModel(
        gameId: state.currentGame!.id,
        teamA: newTeamA,
        teamB: newTeamB,
        teamAScore: ref.read(gameMatchProvider).teamAScore,
        teamBScore: ref.read(gameMatchProvider).teamBScore,
        duration: null,
      ),
      teams: [newTeamA, newTeamB],
    );

    state = state.copyWith(currentGameConfig: newConfig, currentGame: updatedGame);

    ref.read(gameMatchProvider.notifier).updateTeams(newTeamA, newTeamB);
    ref.read(gameScheduleProvider.notifier).updateGameInSchedule(updatedGame);
    ref.read(gameVotesProvider.notifier).initVotes();
  }

  //FUNÇÃO DE VERIFICAÇÃO DE PARTIDA OK
  bool checkGame(GameModel? game) {
    if (state.currentGameConfig != null) return false;
    if (game?.teams?.length == 2) {
      final a = game!.teams![0].players;
      final b = game.teams![1].players;
      return a.isNotEmpty && b.isNotEmpty && a.length == b.length;
    }
    return false;
  }
}

//PROVIDER - GAME SESSION
final gameSessionProvider = NotifierProvider<GameSessionNotifier, GameSessionState>(GameSessionNotifier.new);
