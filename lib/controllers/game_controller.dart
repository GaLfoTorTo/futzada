import 'dart:async';

import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/services/result_service.dart';
import 'package:get/get.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/services/timer_service.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/controllers/event_controller.dart';

class GameController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static GameController get instance => Get.find();
  //INICIALIZAR SERVIÇO DE CRONOMETRO
  final TimerService _timerService = Get.find();
  //INICIALIZAR SERVIÇO DE RESULTADOS
  ResultService _resultService = ResultService();

  //RESGATAR CONTROLLER DO EVENTO
  final EventController eventController = EventController.instance;
  //DEFINIR EVENTO DA PARTIDA
  EventModel? event;
  //DEFINIR CONTROLLADOR DE PARTIDA ATUAL
  GameModel? currentGame;
  //DEFINIR CONTROLLADOR DE CONFIGURAÇÕES DE PARTIDA ATUAL
  GameConfigModel? currentGameConfig;
  //DEFINIR VARIAVEL DE OBSERVAÇÃO DE TEMPO DA PARTIDA
  RxString currentTime = '00:00'.obs;
  //DEFINIR CONTROLADOR DE EQUIPES
  TeamModel teamA = TeamModel(players: []);
  TeamModel teamB = TeamModel(players: []);
  //GETTERS DE TAMANHO DA EQUIPE A E B
  RxInt teamAlength = 0.obs;
  RxInt teamBlength = 0.obs;
  //CONTROLADOR DE PLACAR - EQUIPE A E B
  RxInt teamAScore = 0.obs;
  RxInt teamBScore = 0.obs;
  //DEFINIR CONFIGURAÇÕES DAS PARTIDAS
  //STREAM SUBSTRIPTION
  StreamSubscription<String>? _timeSubscription;

  //FUNÇÃO PARA DEFINIR CONFIGURAÇÕES DA PARTIDA
  void setGameConfig({GameConfigModel? gameConfig}){
    //VERIFICAR SE EXISTE OBJETO DE CONFIGURAÇÕES DE PARTIDAS RECEBIDO POR PARAMETRO
    if(gameConfig != null){
      //RESGATAR CONFIGURAÇÕES DE PARTIDA DO EVENTO
      currentGameConfig = gameConfig;
    }else{
      //RESGATAR CONFIGURAÇÕES DE PARTIDA DO EVENTO
      currentGameConfig = event!.gameConfig!;
    }
  }

  //FUNÇÃO PARA INICIAR UMA PARTIDA
  /// [game]: PARTIDA QUE DEVE SER INICIADA/RETOMADA
  /// [duration]: DURAÇÃO DA PARTIDA
  void startGame(GameModel game) {
    //DEFINIR PARTIDA ATUAL
    currentGame = game;
    //VERIFICAR SE STAUS DA PARTIDA (SE JA FOI INICADA)
    if (game.status != GameStatus.In_progress) {
      //DEFINIR STATUS 
      game.status = GameStatus.In_progress;
      //DEFINIR HORARIO DE INICIO PARA HORARIO ATUAL
      game.startTime = DateTime.now();
    }
    //INICIAR CRONOMETRO COM A DURAÇÃO DA PARTIDA
    _timerService.startStopwatch(game.id, Duration(minutes: game.duration ?? 10));

    //MOVER PARTIDA DA LISTA DE PROXIMOS JOGOS PARA PARTIDAS ACONTECENDO
    eventController.inProgressGames.add(game);
    eventController.nextGames.remove(game);
    //INICIAR ESCUTA DE CRONOMETRO
    _setupTimeListener();
    //ATUALIZAR CONTROLLER
    update();
  }

  //FUNÇÃO PARA PAUSAR PARTIDA
  void pauseGame(GameModel game) {
    _timerService.pauseStopwatch(game.id);
    //ATUALIZAR CONTROLLER
    update([game.id]);
  }

  //FUNÇÃO PARA FINALIZAR PARTIDA
  void finishGame(GameModel game) {
    //FINALIZAR CRONOMETRO E TIMER DA PARTIDA
    _timerService.stopStopwatch(game.id);
    //ADICIONAR STATUS DE CONCLUIDA E ATUALIAR DATA DE TERMINO
    game.status = GameStatus.Completed;
    game.endTime = DateTime.now();

    //MOVER PARTIDA DA LISTA DE PARTIDAS ATUAIS PARA PARTIDAS FINALIZADAS
    eventController.inProgressGames.remove(game);
    eventController.finishedGames.add(game);
    //ATUALIZAR CONTROLLER
    update();
  }

  //FUNÇÃO PARA RESETAR CRONOMETRO DE PARTIDA ATUAL
  void resetGameTimer() {
    //VERIFICAR SE PARTIDA NÃO ESTA VAZIA
    if (currentGame == null) return;
    _timerService.resetStopwatch(currentGame!.id);
    //ATUALIZAR CONTROLLER
    update();
  }

  //GETTER DE TEMPO ATUAL DE PARTIDA EM ANDAMENTO
  String get currentGameTime {
    if(currentGame == null) return '00:00';
    return _timerService.timeStream(currentGame!.id).last.toString();
  }

  //GETTER DE VERIFICAÇÃO DE PARTIDA EM ANDAMENTO
  bool get isGameRunning {
    if (currentGame == null) return false;
    return _timerService.isRunning(currentGame!.id);
  }

  //FUNÇÃO DE DEFINIÇÃO DE STREAM
  void _setupTimeListener() {
    //VERIFICAR SE O JOGO ESTA DEFINIDO
    if (currentGame != null) {
      //ESCUTAR LISTENER DO CRONOMETRO
      _timeSubscription = _timerService.timeStream(currentGame!.id).listen((time) {
        //ATUALIZAR TEMPO DA PARTIDA
        currentTime.value = time;
      });
    }
  }

  @override
  void onClose() {
    _timeSubscription?.cancel();
    if (currentGame != null) {
      _timerService.stopStopwatch(currentGame!.id);
    }
    super.onClose();
  }
}