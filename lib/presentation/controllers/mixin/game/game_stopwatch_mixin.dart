import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:esportly/core/enum/enums.dart';
import 'package:esportly/data/models/result_model.dart';
import 'package:esportly/presentation/controllers/game_controller.dart';

//===MIXIN - CRONÔMETRO===
mixin GameStopwatchMixin on ChangeNotifier implements GameBase {
  //ESTADOS - CRONOMETRO
  String _currentTime = '00:00';
  @override
  String get currentTime => _currentTime;
  set currentTime(String v) { _currentTime = v; notifyListeners(); }

  int _minutesElapsed = 0;
  @override
  int get minutesElapsed => _minutesElapsed;
  set minutesElapsed(int v) { _minutesElapsed = v; notifyListeners(); }

  int _remainingElapsed = 0;
  @override
  int get remainingElapsed => _remainingElapsed;
  set remainingElapsed(int v) { _remainingElapsed = v; notifyListeners(); }

  bool _isGameRunning = false;
  @override
  bool get isGameRunning => _isGameRunning;
  set isGameRunning(bool v) { _isGameRunning = v; notifyListeners(); }

  //FUNÇÃO PARA INICIAR UMA PARTIDA
  void startGame() {
    GameController gameController = GameController.instance;
    if (gameController.currentGame.status != GameStatus.InProgress) {
      gameController.currentGame.status = GameStatus.InProgress;
      gameController.currentGame.startTime = DateTime.now();
    }
    timerService.startStopwatch(
      gameController.currentGame.id,
      Duration(minutes: gameController.currentGame.duration ?? 10)
    );
    gameController.inProgressGames.add(gameController.currentGame);
    gameController.nextGames.remove(gameController.currentGame);
    _setupTimeListener();
    isGameRunning = true;
    notifyListeners();
  }

  //FUNÇÃO PARA PAUSAR PARTIDA
  void pauseGame() {
    GameController gameController = GameController.instance;
    timerService.pauseStopwatch(gameController.currentGame.id);
    isGameRunning = false;
  }

  //FUNÇÃO PARA FINALIZAR PARTIDA
  void stopGame() {
    GameController gameController = GameController.instance;
    timerService.stopStopwatch(gameController.currentGame.id);
    gameController.currentGame.status = GameStatus.Completed;
    gameController.currentGame.endTime = DateTime.now();
    gameController.inProgressGames.remove(gameController.currentGame);
    gameController.addGameHistoric(gameController.currentGame);
    isGameRunning = false;
    ResultModel(
      gameId: currentGame.id,
      teamA: teamA,
      teamB: teamB,
      teamAScore: teamAScore,
      teamBScore: teamBScore,
      duration: gameController.currentGame.endTime!.difference(gameController.currentGame.startTime!).inMinutes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  //FUNÇÃO PARA RESETAR CRONOMETRO DE PARTIDA ATUAL
  void resetGame() {
    GameController gameController = GameController.instance;
    timerService.resetStopwatch(gameController.currentGame.id);
    gameController.currentGame.status = GameStatus.Scheduled;
    gameController.inProgressGames.remove(gameController.currentGame);
    gameController.nextGames.add(gameController.currentGame);
    isGameRunning = false;
  }

  //FUNÇÃO DE DEFINIÇÃO DE STREAM
  void _setupTimeListener() {
    late final gameController = this as GameController;
    final id = gameController.currentGame.id;
    final clockStream = timerService.clockStream(id);
    final elapsedStream = timerService.elapsedStream(id);
    gameController.timeSubscription = rxdart.CombineLatestStream.combine2<String, int, void>(
      clockStream,
      elapsedStream,
      (clock, elapsed) {
        currentTime = clock;
        minutesElapsed = elapsed;
      },
    ).listen((_) {});
  }

  //GETTER DE TEMPO ATUAL DE PARTIDA EM ANDAMENTO
  String get currentGameTime {
    GameController gameController = GameController.instance;
    if (gameController.currentGame.id.toString().isNotEmpty) return '00:00';
    return timerService.clockStream(currentGame.id).last.toString();
  }
}
