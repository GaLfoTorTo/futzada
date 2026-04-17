import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/result_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - CRONÔMETRO===
mixin GameStopwatchMixin on GetxController implements GameBase{
  //ESTADOS - CRONOMETRO
  @override
  final RxString currentTime = '00:00'.obs;
  @override
  final RxInt minutesElapsed = 0.obs;
  @override
  final RxInt remainingElapsed = 0.obs;
  @override
  final RxBool isGameRunning = false.obs;

  //FUNÇÃO PARA INICIAR UMA PARTIDA
  void startGame() {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    //VERIFICAR SE STAUS DA PARTIDA (SE JA FOI INICADA)
    if (gameController.currentGame.status != GameStatus.InProgress) {
      ////ATUALIZAR STATUS PARA EM PROGRESSO
      gameController.currentGame.status = GameStatus.InProgress;
      //DEFINIR HORARIO DE INICIO PARA HORARIO ATUAL
      gameController.currentGame.startTime = DateTime.now();
    }
    //INICIAR CRONOMETRO COM A DURAÇÃO DA PARTIDA
    timerService.startStopwatch(gameController.currentGame.id, Duration(minutes: gameController.currentGame.duration ?? 10));

    //MOVER PARTIDA DA LISTA DE PROXIMAS PARTIDAS PARA PARTIDAS EM ANDAMENTO
    gameController.inProgressGames.add(gameController.currentGame);
    gameController.nextGames.remove(gameController.currentGame);
    //INICIAR ESCUTA DE CRONOMETRO
    _setupTimeListener();
    //DEFINIR OBSERVADOR DA PARTIDA COMO EM ANDAMENTO
    gameController.isGameRunning.value = true;
    //ATUALIZAR CONTROLLER
    gameController.update();
  }

  //FUNÇÃO PARA PAUSAR PARTIDA
  void pauseGame() {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    timerService.pauseStopwatch(gameController.currentGame.id);
    //DEFINIR OBSERVADOR DA PARTIDA COMO PAUSADO
    gameController.isGameRunning.value = false;
    //ATUALIZAR CONTROLLER
    gameController.update([gameController.currentGame.id]);
  }

  //FUNÇÃO PARA FINALIZAR PARTIDA
  void stopGame() {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    //FINALIZAR CRONOMETRO E TIMER DA PARTIDA
    timerService.stopStopwatch(gameController.currentGame.id);
    //ATUALIZAR STATUS PARA COMPLETO
    gameController.currentGame.status = GameStatus.Completed;
    gameController.currentGame.endTime = DateTime.now();
    //MOVER PARTIDA DA LISTA DE PARTIDAS ATUAIS PARA PARTIDAS FINALIZADAS
    gameController.inProgressGames.remove(gameController.currentGame);
    gameController.addGameHistoric(gameController.currentGame);
    //DEFINIR OBSERVADOR DA PARTIDA COMO FINALIZADO
    gameController.isGameRunning.value = false;
    //DEFINIR RESULTADO DA PARTIDA
    ResultModel(
      gameId: currentGame.id,
      teamA: teamA,
      teamB: teamB,
      teamAScore: teamAScore.value,
      teamBScore: teamBScore.value,
      duration: gameController.currentGame.endTime!.difference(gameController.currentGame.startTime!).inMinutes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    //ATUALIZAR CONTROLLER
    gameController.update();
  }

  //FUNÇÃO PARA RESETAR CRONOMETRO DE PARTIDA ATUAL
  void resetGame() {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    //RESETAR CRONOMETRO
    timerService.resetStopwatch(gameController.currentGame.id);
    //ATUALIZAR STATUS PARA AGENDADOS
    gameController.currentGame.status = GameStatus.Scheduled;
    //MOVER PARTIDA DA LISTA DE PROXIMOS PARTIDAS EM ANDAMENTO PARA PROXIMAS PARTIDAS 
    gameController.inProgressGames.remove(gameController.currentGame);
    gameController.nextGames.add(gameController.currentGame);
    //DEFINIR OBSERVADOR DA PARTIDA COMO FINALIZADO
    gameController.isGameRunning.value = false;
    //ATUALIZAR CONTROLLER
    gameController.update();
  }

  //FUNÇÃO DE DEFINIÇÃO DE STREAM
  void _setupTimeListener() {
    //RESGATAR INSTANCIA DO CONTROLLER
    late final gameController = this as GameController;
    //RESGATAR CONTROLLER PRINCIPAL
    final id = gameController.currentGame.id;
    //REGISTRAR STREMS DE CRONOMETRO
    final clockStream = timerService.clockStream(id);
    final elapsedStream = timerService.elapsedStream(id);
    //ESCUTAR LISTENERS DO CRONOMETRO
    gameController.timeSubscription = rxdart.CombineLatestStream.combine2<String, int, void>(
      clockStream,
      elapsedStream,
      (clock, elapsed) {
        currentTime.value = clock;
        minutesElapsed.value = elapsed;
      },
    ).listen((_) {});
  }

  //GETTER DE TEMPO ATUAL DE PARTIDA EM ANDAMENTO
  String get currentGameTime {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    //VERIFICAR SE PARTIDA NÃO ESTA VAZIA
    if(gameController.currentGame.id.toString().isNotEmpty) return '00:00';
    return timerService.clockStream(currentGame.id).last.toString();
  }
}