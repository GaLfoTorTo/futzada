import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/services/game_service.dart';
import 'package:get/get.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/services/timer_service.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/result_model.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:intl/intl.dart';

//===DEPENDENCIAS BASE===
abstract class GameBase {
  //GETTER - SERVIÇO DE PARTIDAS
  GameService get gameService;
  //GETTER - SERVIÇO DE CRONOMETRO
  TimerService get timerService;
  //GETTER - EVENTO
  EventModel? get event;
  //ESTADO PARTIDA
  GameModel get currentGame;
  //GETTER - CONFIGURAÇÕES DAS PARTIDAS
  GameConfigModel? get currentGameConfig;

  //===PARTIDA===
  //ESTADO - EQUIPES DA PARTIDA
  TeamModel get teamA;
  TeamModel get teamB;
  //ESTADO - QUANTIDADE DE JOGADORES NAS EQUIPES NA PARTIDA
  RxInt get teamAlength;
  RxInt get teamBlength;
  //ESTADO - PLACAR EQUIPES NA PARTIDA
  RxInt get teamAScore;
  RxInt get teamBScore;

  //===PARTIDA AO VIVO===
  //ESTADO - HORARIO DA PARTIDA
  RxString get currentTime;
  //ESTADO - MINUTOS DA PARTIDA
  RxInt get minutesElapsed;
  //ESTADO - MINUTOS DA FALTANTES
  RxInt get remainingElapsed;
  //ESTADO - STATUS DE PARTIDA EM CURSO
  RxBool get isGameRunning;
  //ESTADO - DIA DO EVENTO
  DateTime? get eventDate;
}

class GameController extends GetxController
  with GameMatchMixin, GameConfigMixin, GameStopwatchMixin, GamesEventMixin{
  //GETTER DE CONTROLLERS
  static GameController get instance => Get.find();
  final EventController eventController = EventController.instance;
  
  //STREAM - CRONOMETRO
  StreamSubscription<dynamic>? _timeSubscription;

  //GETTER DE SERVIÇOS
  @override
  GameService gameService = GameService();
  @override
  TimerService timerService = TimerService();
  
  //GETTER DE ESTADOS
  @override
  late EventModel event;
  @override
  late GameModel currentGame;
  @override
  late DateTime? eventDate;
  @override
  late GameConfigModel? currentGameConfig;

  @override
  void onInit() {
    super.onInit();
    //RESGATAR DATA DO EVENTO
    //eventDate = eventService.getNextEventDate(event);
    //VARAIVEIS PRA TESTE
    eventDate = DateFormat("dd/MM/yyyy").parse("20/06/2025");
  }

  @override
  void onClose() {
    //LIMPAR SUBCRIBES DO STREAM
    _timeSubscription?.cancel();
    
    //ENCERRAR CRONOMETRO DE TODAS AS PARTIDAS ATIVAS
    inProgressGames.forEach((game) {
      //VERIFICAR SE PARTIDA NÃO ESTA VAZIA
      if (game != null) {
        timerService.stopStopwatch(game.id);
      }
    });
    //ENCERRAR CRONOMETRO DA PARTIDA ATUAL
    timerService.stopStopwatch(currentGame.id);
    //ENCERRAR CONTROLLER
    super.onClose();
  }
}

//===MIXIN - PARTIDA ATUAL===
mixin GameMatchMixin on GetxController implements GameBase{
  //ESTADO - EQUIPES DA PARTIDA
  @override
  TeamModel teamA = TeamModel(players: []);
  @override
  TeamModel teamB = TeamModel(players: []);
  @override
  RxInt teamAlength = 0.obs;
  @override
  RxInt teamBlength = 0.obs;
  @override
  RxInt teamAScore = 0.obs;
  @override
  RxInt teamBScore = 0.obs;

  //FUNÇÃO PARA DEFINIR TIME ESPECIFICO DA PARTIDA
  void setTeam(TeamModel team, bool flag) {
    //VERIFICAR FLAG E DEFINIR EQUIPE
    if(flag == true){
      teamA = team;
    }else{
      teamB = team;
    }
  }

  //FUNÇÃO PARA DEFINIR TIMES DA PARTIDA
  void setTeams(GameModel game) {
    game.teams = [teamA, teamB];
  }

  //FUNÇÃO PARA DEFINIR CONFIGURAÇÕES DA PARTIDA
  void setGame() {
    //RESGATAR INSTANCIA DO CONTROLLER
    GameController gameController = GameController.instance;
    //RESGATAR DURAÇÃO TOTAL DA PARTIDA
    int totalDuration = gameController.currentGameConfig!.hasTwoHalves! 
      ? int.parse(gameController.durationController.text) * 2 
      : int.parse(gameController.durationController.text);

    //INICIALIZAR RESULTADO DA PARTIDA
    final result = ResultModel(
      teamA: teamA, 
      teamB: teamB, 
      teamAScore: teamAScore.value, 
      teamBScore: teamBScore.value, 
      duration: null
    );
    //ATUALIZAR EQUIPES DA PARTIDA
    gameController.teamA = TeamModel(
      id: gameController.teamA.id,
      uuid: gameController.teamA.uuid,
      name: gameController.teamANameController.text,
      emblema: gameController.teamAEmblemaController.text,
      players: teamA.players,
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
    gameController.teamB = TeamModel(
      id: gameController.teamB.id,
      uuid: gameController.teamB.uuid,
      name: gameController.teamBNameController.text,
      emblema: gameController.teamBEmblemaController.text,
      players: teamB.players,
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
    //ATUALIZAR PARTIDA ATUAL
    gameController.currentGame = gameController.currentGame.copyWith(
      id : gameController.currentGame.id,
      number : gameController.currentGame.number,
      event : null,
      referee : gameController.refereerController,
      duration : int.parse(gameController.durationController.text),
      startTime : DateFormat.Hm().parse(gameController.startTimeController.text),
      endTime : gameController.currentGame.startTime!.add(Duration(minutes: totalDuration)),
      status : gameController.currentGame.status,
      result : result,
      teams : [ gameController.teamA, gameController.teamB ],
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
  }
}

//===MIXIN - CONFIGURAÇÕES DAS PARTIDAS===
mixin GameConfigMixin on GetxController implements GameBase{
  //CONTROLLERS DE CAMPOS DE CONFIGURAÇÕES
  late TextEditingController numberController;
  late TextEditingController categoryController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController durationController;
  late TextEditingController hasTwoHalvesController;
  late TextEditingController hasExtraTimeController;
  late TextEditingController hasPenaltyController;
  late TextEditingController hasGoalLimitController;
  late TextEditingController hasRefereerController;
  late TextEditingController playersPerTeamController;
  late TextEditingController extraTimeController;
  late TextEditingController goalLimitController;
  late ParticipantModel? refereerController;
  //CONTROLADORES DE CAMPOS DE EQUIPE
  late TextEditingController teamANameController;
  late TextEditingController teamAEmblemaController;
  late TextEditingController teamBNameController;
  late TextEditingController teamBEmblemaController;
  late TextEditingController qtdPlayersController;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS
  void initTextControllers() {
    numberController = TextEditingController(text: currentGame.number.toString());
    categoryController = TextEditingController(text: event!.category);
    startTimeController = TextEditingController(text: DateFormat.Hm().format(currentGame.startTime!));
    endTimeController = TextEditingController(text: DateFormat.Hm().format(currentGame.endTime!));
    durationController = TextEditingController(text: event!.gameConfig?.duration.toString() ?? '');
    hasTwoHalvesController = TextEditingController(text: currentGameConfig!.hasTwoHalves.toString());
    hasExtraTimeController = TextEditingController(text: currentGameConfig!.hasExtraTime.toString());
    hasPenaltyController = TextEditingController(text: currentGameConfig!.hasPenalty.toString());
    hasGoalLimitController = TextEditingController(text: currentGameConfig!.hasGoalLimit.toString());
    hasRefereerController = TextEditingController(text: currentGameConfig!.hasRefereer.toString());
    playersPerTeamController = TextEditingController(text: currentGameConfig!.playersPerTeam.toString());
    extraTimeController = TextEditingController(text: currentGameConfig!.extraTime.toString());
    goalLimitController = TextEditingController(text: currentGameConfig!.goalLimit.toString());
    goalLimitController = TextEditingController(text: event!.gameConfig?.goalLimit.toString() ?? '');
    refereerController = currentGame.referee ?? event!.participants![0];
    teamANameController = TextEditingController(text: currentGame.teams?.first.name?.toString() ?? '');
    teamBNameController = TextEditingController(text: currentGame.teams?.last.name?.toString() ?? '');
    teamAEmblemaController = TextEditingController(text: currentGame.teams?.first.emblema?.toString() ?? 'emblema_1');
    teamBEmblemaController = TextEditingController(text: currentGame.teams?.last.emblema?.toString() ?? 'emblema_2');
    qtdPlayersController = TextEditingController(text: event!.gameConfig?.playersPerTeam.toString() ?? '');
  }

  //FUNÇÃO DE DEFINIÇÃO DE CONFIGURAÇÕES DA PARTIDA
  void setGameConfig() {
    //RESGATAR INSTANCIA DO CONTROLLER
    GameController gameController = GameController.instance;
    //ATUALIZAR CONFIGURAÇÕES DE PARTIDA
    gameController.currentGameConfig = GameConfigModel(
      id: currentGameConfig!.id,
      category: categoryController.text,
      duration: int.parse(durationController.text),
      hasTwoHalves: bool.parse(hasTwoHalvesController.text),
      hasExtraTime: bool.parse(hasExtraTimeController.text),
      hasPenalty: bool.parse(hasPenaltyController.text),
      hasGoalLimit: bool.parse(hasGoalLimitController.text),
      hasRefereer: bool.parse(hasRefereerController.text),
      playersPerTeam: int.parse(playersPerTeamController.text),
      extraTime: bool.parse(hasExtraTimeController.text) ? int.parse(extraTimeController.text) : null,
      goalLimit: bool.parse(hasGoalLimitController.text) ? int.parse(goalLimitController.text) : null,
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
    //SALVAR CONFIGURAÇÕES DO EVENTO
    event!.gameConfig = gameController.currentGameConfig;
    //EXIBIR MENSAGEM DE SUCESSO
    AppHelper.feedbackMessage(Get.context, "Configurações Salvas com sucesso", type: "Success");
  }

  //FUNÇÃO PARA VERIFICAR SE PARTIDA ESTA CONFIGURADA PARA INICIAR
  bool checkGame(GameModel? game){
    //RESGATAR INSTANCIA DO CONTROLLER
    GameController gameController = GameController.instance;
    //VERIFICAR SE PARTIDA ESTA COM AS CONFIGURAÇÕES DEFINIDAS
    if(gameController.currentGameConfig == null){
      //VERIFICAR SE EQUIPES DA PARTIDA ESTÃO DEFINIDAS
      if(game!.teams != null){
        //VERIFICAR SE JOGADORES DAS DUAS EQUIPES ESTÃO DEFINDOS
        if(game.teams!.first.players.isNotEmpty && game.teams!.first.players.isNotEmpty){
          //VERIFICAR SE AS DUAS EQUIPES TEM A MESMA QUANTIDADE DE JOGADORES
          if(game.teams!.first.players.length == game.teams!.first.players.length){
            return true;
          }
        }
      }
    }
    return false;
  }
}

//===MIXIN - PARTIDAS DO EVENTO===
mixin GamesEventMixin on GetxController implements GameBase{
  //RESGATAR DATA DO DIA
  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //ESTADO DE CARREGAMENTO DE PARTIDAS
  final loadGames = false.obs;
  final hasGames = true.obs;
  //ESTADO DE CARREGAMENTO DE PARTIDAS
  final loadHistoricGames = false.obs;
  //ESTADO - QTD CARDS VISIVEIS
  var qtdView = 3.obs;  
  //ESTADO - PARTIDAS (EM CURSO, PROXIMAS, AGENDADAS, FINALIZADAS)
  final RxList<GameModel?> inProgressGames = <GameModel?>[].obs;
  final RxList<GameModel?> nextGames = <GameModel?>[].obs;
  final RxList<GameModel?> scheduledGames = <GameModel?>[].obs;
  final RxMap<String, List<GameModel>?> finishedGames = <String, List<GameModel>?>{}.obs;

  //FUNÇÃO DE BUSCA DE HISTÓRICO
  Future<bool> getHistoricGames() async {
    // RESETAR ESTADO DE CARREGAMENTO
    loadHistoricGames.value = false;
    //DEFINIR MAPA DE PARTIDAS DO HISTÓRICO
    Map<String, List<GameModel>> mapGames = {};
    try {
      //DELAY DE SIMULAÇÃO
      await Future.delayed(const Duration(seconds: 3));
      //REMOVER ITENS DO HISTÓRICO
      finishedGames.value = mapGames;
      //BUSCAR PARTIDAS DO EVENTO (SIMULAÇÃO)
      final games = gameService.getHistoricGames(event!);
      //VERIFICAR SE EXISTEM PARTIDAS FINALIZADAS
      if (games.isNotEmpty) {
        //LOOP NAS PARTIDAS
        for (var item in games) {
          //RESGATAR DIA E MÊS DA PARTIDA
          final dateKey = DateFormat('d/MM').format(item!.createdAt!);
          //ADICIONAR PARTIDA AO MAPA
          mapGames.putIfAbsent(dateKey, () => []).add(item);
        }
        //RESGATAR PARTIDAS FINALIZADAS (HISTÓRICO)
        finishedGames.assignAll(mapGames);
      }
      //RETORNAR VALOR PARA ESTADO DE CARREGAMENTO
      return true;
    } catch (e) {
      print('Erro ao buscar partidas: $e');
      return false;
    }
  }
  
  //FUNÇÃO PARA ADICIONAR PARTIDA AO ARRAY DE PARTIDSA FINALIZADAS
  void addGameHistoric(GameModel game) {
    //RESGATAR DATA DE CRIAÇÃO DA PARTIDA
    String data = DateFormat('d/MM').format(game.createdAt!);
    //VERIFICAR SE OUTRA PARTIDA FOI FINALIZADA NO MESMO DIA
    if (finishedGames.containsKey(data)) {
      //ADICIONAR A CHAVE EXISTENTE
      finishedGames[data]!.add(game);
      finishedGames[data] = List.from(finishedGames[data]!);
    } else {
      //CRIAR NOVA CHAVE E ADICIONAR
      finishedGames[data] = [game];
    }
}
  
  //FUNÇÃO DE BUSCA DE PARTIDAS DO EVENTO
  Future<bool> setGamesEvent(EventModel event) async{
    //RESETAR ESTADO DE CARREGAMENTO
    loadGames.value = false;
    //RESETAR LISTA DE PARIDAS
    nextGames.value = [];
    scheduledGames.value = [];
    try {
      await Future.delayed(const Duration(seconds: 3));
      //BUSCAR PARTIDAS DO EVENTO (SIMULAÇÃO)
      final games = gameService.getScheduledGames(event, event.gameConfig!.duration!);
      //VERIFICAR SE EVENTO ESTA ACONTECENDO HOJE
      if(today.isAtSameMomentAs(eventDate!)){
        //VERIFICAR SE EXISTEM PARTIDAS FINALIZADAS
        if(games.isNotEmpty){
          //GERAR PROXIMAS PARTIDAS DO DIA 
          nextGames.assignAll(games.toList());
          //ATUALIZAR ESTADO DE PARTIDAS
          hasGames.value = true;
        }
      }else{
        //GERAR PARTIDAS PROGRAMADAS AUTOMATICAMENTE
        if(games.isNotEmpty){
          //GERAR PROXIMAS PARTIDAS DO DIA 
          scheduledGames.assignAll(games.toList());
          //ATUALIZAR ESTADO DE PARTIDAS
          hasGames.value = true;
        }
      }
      //RETORNAR VALOR PARA ESTADO DE CARREGAMENTO
      return true;
    } catch (e) {
      print('Erro ao buscar partidas: $e');
      //ATUALIZAR ESTADO DE CARREGAMENTO
      hasGames.value = false;
      //RETORNAR VALOR PARA ESTADO DE CARREGAMENTO
      return true;
    }
  }

  //FUNÇÃO PARA DEFINIR QUANTIDADE DE ITENS VISIVEIS
  void setView(bool view, int qtdGames){
    //VERIFICAR SE PRECISA EXIBIR OU ESCONDER PARTIDAS
    if(view){
      int increment = qtdGames - qtdView.value;
      qtdView.value = increment > 3 ? qtdView.value + 3 : qtdView.value + increment;
    }else{
      qtdView.value = qtdView.value - 3 > 3 ? qtdView.value - 3 : 3;
    }
  }
}

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
  /// [game]: PARTIDA QUE DEVE SER INICIADA/RETOMADA
  /// [duration]: DURAÇÃO DA PARTIDA
  void startGame() {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    //VERIFICAR SE STAUS DA PARTIDA (SE JA FOI INICADA)
    if (gameController.currentGame.status != GameStatus.In_progress) {
      ////ATUALIZAR STATUS PARA EM PROGRESSO
      gameController.currentGame.status = GameStatus.In_progress;
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
    ////ATUALIZAR STATUS PARA COMPLETO
    gameController.currentGame.status = GameStatus.Completed;
    gameController.currentGame.endTime = DateTime.now();
    //MOVER PARTIDA DA LISTA DE PARTIDAS ATUAIS PARA PARTIDAS FINALIZADAS
    gameController.inProgressGames.remove(gameController.currentGame);
    gameController.addGameHistoric(gameController.currentGame);
    //DEFINIR OBSERVADOR DA PARTIDA COMO FINALIZADO
    gameController.isGameRunning.value = false;
    //DEFINIR RESULTADO DA PARTIDA
    ResultModel(
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

  //GETTER DE TEMPO ATUAL DE PARTIDA EM ANDAMENTO
  String get currentGameTime {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    //VERIFICAR SE PARTIDA NÃO ESTA VAZIA
    if(gameController.currentGame == null) return '00:00';
    return timerService.stopwatchStream(currentGame.id, 'clock').last.toString();
  }

  //FUNÇÃO DE DEFINIÇÃO DE STREAM
  void _setupTimeListener() {
    //RESGATAR CONTROLLER PRINCIPAL
    GameController gameController = GameController.instance;
    //ESCUTAR LISTENER DO CRONOMETRO (TEMPO)
    gameController._timeSubscription = timerService.stopwatchStream(currentGame.id, 'clock').listen((time) {
      //ATUALIZAR TEMPO DA PARTIDA
      currentTime.value = time;
    });
    //ESCUTAR LISTENER DO CRONOMETRO (MINUTOS PASSADOS)
    gameController._timeSubscription = timerService.stopwatchStream(currentGame.id, 'elapsed').listen((time) {
      //ATUALIZAR TEMPO DA PARTIDA
      minutesElapsed.value = time;
    });
  }
}