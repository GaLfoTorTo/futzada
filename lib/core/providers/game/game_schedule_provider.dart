import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/game_model.dart';
import 'package:esportly/data/services/game_service.dart';

//ESTADO - GAME SCHEDULE
class GameScheduleState {
  final bool loadGames;
  final bool hasGames;
  final bool loadHistoricGames;
  final int qtdView;
  final DateTime? eventDate;
  final List<GameModel?> inProgressGames;
  final List<GameModel?> nextGames;
  final List<GameModel?> scheduledGames;
  final Map<String, List<GameModel>?> finishedGames;

  const GameScheduleState({
    this.loadGames = false,
    this.hasGames = true,
    this.loadHistoricGames = false,
    this.qtdView = 3,
    this.eventDate,
    this.inProgressGames = const [],
    this.nextGames = const [],
    this.scheduledGames = const [],
    this.finishedGames = const {},
  });

  GameScheduleState copyWith({
    bool? loadGames,
    bool? hasGames,
    bool? loadHistoricGames,
    int? qtdView,
    DateTime? eventDate,
    List<GameModel?>? inProgressGames,
    List<GameModel?>? nextGames,
    List<GameModel?>? scheduledGames,
    Map<String, List<GameModel>?>? finishedGames,
  }) => GameScheduleState(
    loadGames: loadGames ?? this.loadGames,
    hasGames: hasGames ?? this.hasGames,
    loadHistoricGames: loadHistoricGames ?? this.loadHistoricGames,
    qtdView: qtdView ?? this.qtdView,
    eventDate: eventDate ?? this.eventDate,
    inProgressGames: inProgressGames ?? this.inProgressGames,
    nextGames: nextGames ?? this.nextGames,
    scheduledGames: scheduledGames ?? this.scheduledGames,
    finishedGames: finishedGames ?? this.finishedGames,
  );
}

//NOTIFICADOR - GAME SCHEDULER
class GameScheduleNotifier extends Notifier<GameScheduleState> {
  late final GameService _gameService;

  @override
  GameScheduleState build() {
    _gameService = GameService();
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return GameScheduleState(eventDate: today);
  }

  //FUNÇÃO DE VERIFICAÇÃO DE PARTIDA HOJE
  bool isToday() {
    final eventDate = state.eventDate;
    if (eventDate == null) return false;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return today.isAtSameMomentAs(eventDate);
  }

  //FUNÇÃO DE DEFINIÇÃO DE PARITDA DO EVENTO
  Future<bool> setGamesEvent(EventModel event) async {
    state = state.copyWith(loadGames: false);
    try {
      await Future.delayed(const Duration(seconds: 3));
      final games = _gameService.getListGames(event);
      if (games.isNotEmpty) {
        if (isToday()) {
          state = state.copyWith(nextGames: games, hasGames: true, loadGames: true);
        } else {
          state = state.copyWith(scheduledGames: games, hasGames: true, loadGames: true);
        }
      } else {
        state = state.copyWith(hasGames: false, loadGames: true);
      }
      return true;
    } catch (_) {
      state = state.copyWith(hasGames: false, loadGames: true);
      return false;
    }
  }

  //FUNÇÃO DE BUSCA DE HISTÓRICO DE PARTIDAS DO EVENTO
  Future<bool> getHistoricGames(EventModel event) async {
    state = state.copyWith(loadHistoricGames: false);
    try {
      await Future.delayed(const Duration(seconds: 3));
      final games = _gameService.getListGames(event);
      final Map<String, List<GameModel>> mapGames = {};
      for (final item in games) {
        if (item == null) continue;
        final key = DateFormat('d/MM').format(item.createdAt!);
        mapGames.putIfAbsent(key, () => []).add(item);
      }
      state = state.copyWith(finishedGames: mapGames, loadHistoricGames: true);
      return true;
    } catch (_) {
      state = state.copyWith(loadHistoricGames: true);
      return false;
    }
  }

  //FUNÇÃO DE ADIÇÃO DE PARTIDA AO HISTÓRICO
  void addGameHistoric(GameModel game) {
    final key = DateFormat('d/MM').format(game.createdAt!);
    final updated = Map<String, List<GameModel>?>.from(state.finishedGames);
    if (updated.containsKey(key)) {
      updated[key] = [...updated[key]!, game];
    } else {
      updated[key] = [game];
    }
    state = state.copyWith(finishedGames: updated);
  }

  //FUNÇÃO DE MOVIMENTAÇÃO DE PARTIDA PARA EM PROGRESSO
  void moveToInProgress(GameModel game) {
    state = state.copyWith(
      inProgressGames: [...state.inProgressGames, game],
      nextGames: state.nextGames.where((g) => g?.id != game.id).toList(),
    );
  }
  //FUNÇÃO DE REMOVER PARTIDA DE EM PROGRESSO
  void removeFromInProgress(GameModel game) {
    state = state.copyWith(
      inProgressGames: state.inProgressGames.where((g) => g?.id != game.id).toList(),
    );
  }

  //FUNÇÃO DE RETORNO PARA PROXIMAS PARTIDAS
  void backToNext(GameModel game) {
    state = state.copyWith(
      inProgressGames: state.inProgressGames.where((g) => g?.id != game.id).toList(),
      nextGames: [...state.nextGames, game],
    );
  }

  //FUNÇÃO DE ATUALIZAÇÃO DE PARTIDA AGENDADA
  void updateGameInSchedule(GameModel game) {
    final idx = state.nextGames.indexWhere((g) => g?.id == game.id);
    if (idx == -1) return;
    final updated = [...state.nextGames];
    updated[idx] = game;
    state = state.copyWith(nextGames: updated);
  }

  //FUNÇÃO DE DEFINIÇÃO DE VISUALIZAÇÃO DE PARTIDAS
  void setView(bool expand, int totalGames) {
    final current = state.qtdView;
    if (expand) {
      final diff = totalGames - current;
      state = state.copyWith(qtdView: diff > 3 ? current + 3 : current + diff);
    } else {
      state = state.copyWith(qtdView: current - 3 > 3 ? current - 3 : 3);
    }
  }
}

//PROVIDER - GAME SCHEDULE
final gameScheduleProvider = NotifierProvider<GameScheduleNotifier, GameScheduleState>(GameScheduleNotifier.new);
