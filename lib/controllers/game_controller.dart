import 'dart:async';
import 'package:futzada/models/game_event_model.dart';
import 'package:futzada/services/game_event_service.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/services/game_service.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/services/timer_service.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/result_model.dart';
import 'package:futzada/controllers/event_controller.dart';

//===DEPENDENCIAS BASE===
abstract class GameBase {
  //GETTER - SERVIÇO DE PARTIDAS
  GameService get gameService;
  //GETTER - SERVIÇO DE EVENTOS DA PARTIDA
  GameEventService get gameEventService;
  //GETTER - SERVIÇO DE CRONOMETRO
  TimerService get timerService;
  //GETTER - EVENTO
  EventModel? get event;
  //GETTER - CONFIGURAÇÕES DAS PARTIDAS
  GameConfigModel? get currentGameConfig;
  //ESTADO PARTIDA
  GameModel get currentGame;

  //===DIA DE PARTIDA===
  RxList<ParticipantModel>? get participantsPresent;
  RxMap<String, double> get votesGame;
  RxMap<String, int>? get votesMVP;
  RxInt get votesGameCount;
  RxInt get votesMVPCount;
  
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
  //ESTADO - ESTATISTICAS
  RxInt get teamACorners;
  RxInt get teamBCorners;
  RxInt get teamAFouls;
  RxInt get teamBFouls;
  RxInt get teamADefense;
  RxInt get teamBDefense;
  RxInt get teamAOffside;
  RxInt get teamBOffside;
  RxInt get teamAPasses;
  RxInt get teamBPasses;
  RxInt get teamAPossesion;
  RxInt get teamBPossesion;
  RxInt get teamAShots;
  RxInt get teamBShots;
  RxInt get teamAShotsGoal;
  RxInt get teamBShotsGoal;
  RxInt get teamAYellowCard;
  RxInt get teamBYellowCard;
  RxInt get teamARedCard;
  RxInt get teamBRedCard;
  //ESTADO LISTA DE EVENTOS DA PARTIDA
  RxList<GameEventModel> get gameEvents;


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
  with GameConfigMixin, GameDayEventMixin, GameScheduleMixin, GameMatchMixin, GameVotesMixin, GameStopwatchMixin{
  //GETTER DE CONTROLLERS
  static GameController get instance => Get.find();
  final EventController eventController = EventController.instance;
  
  //STREAM - CRONOMETRO
  StreamSubscription<dynamic>? _timeSubscription;

  //GETTER DE SERVIÇOS
  @override
  GameService gameService = GameService();
  @override
  GameEventService gameEventService = GameEventService();
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
    eventDate = DateFormat("dd/MM/yyyy").parse("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
  }

  @override
  void onClose() {
    //LIMPAR SUBCRIBES DO STREAM
    _timeSubscription?.cancel();
    //FINALIZAR CONTROLLERS DE TEXTO
    disposeTextControllers();
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
    categoryController = TextEditingController(text: event!.gameConfig!.category);
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

  //FUNÇÃO PARA FINALIZAR CONTROLLERS
  void disposeTextControllers(){
    numberController.dispose();
    categoryController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    durationController.dispose();
    hasTwoHalvesController.dispose();
    hasExtraTimeController.dispose();
    hasPenaltyController.dispose();
    hasGoalLimitController.dispose();
    hasRefereerController.dispose();
    playersPerTeamController.dispose();
    extraTimeController.dispose();
    goalLimitController.dispose();
    goalLimitController.dispose();
    teamANameController.dispose();
    teamBNameController.dispose();
    teamAEmblemaController.dispose();
    teamBEmblemaController.dispose();
    qtdPlayersController .dispose();
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
      if (game!.teams?.length == 2) {
        final playersA = game.teams![0].players;
        final playersB = game.teams![1].players;
        //VERIFICAR SE AS DUAS EQUIPES TEM A MESMA QUANTIDADE DE JOGADORES
        return playersA.isNotEmpty && playersB.isNotEmpty && playersA.length == playersB.length;
      }
      return false;
    }
    return false;
  }
}

//===MIXIN - DIA DE EVENTO===
mixin GameDayEventMixin on GetxController implements GameBase{
  @override
  RxList<ParticipantModel> participantsPresent = <ParticipantModel>[].obs;
}

//===MIXIN - VOTES===
mixin GameVotesMixin on GetxController implements GameBase{
  //ESTADOS - VOTOS
  @override
  RxInt votesGameCount = 25.obs;
  @override
  RxInt votesMVPCount = 25.obs;
  @override
  RxMap<String, double> votesGame = <String, double>{}.obs;
  @override
  RxMap<String, int> votesMVP = <String, int>{}.obs;

  //FUNÇÃO DE DEFINIÇÃO DE OPÇÕES DE VOTO
  void setVotesGame() {
    //LIMPAR LISTA
    votesGame.clear();
    //ADICIONAR JOGADORES DA EQUIPE A
    votesGame.value = {
      "team1": 70,
      "draw": 20,
      "team2": 10,
    };
  }
  //FUNÇÃO DE DEFINIÇÃO DE OPÇÕES DE VOTO
  void setVotesMVP() {
    //LIMPAR LISTA
    votesMVP.clear();
    //ADICIONAR JOGADORES DA EQUIPE A
    votesMVP.addAll({
      for (final p in teamA.players) p.user.uuid!: 0,
    });
    //ADICIONAR JOGADORES DA EQUIPE B
    votesMVP.addAll({
      for (final p in teamB.players) p.user.uuid!: 0,
    });
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
  RxList<GameEventModel> gameEvents = <GameEventModel>[].obs;
  @override
  RxInt teamAlength = 0.obs;
  @override
  RxInt teamBlength = 0.obs;
  @override
  RxInt teamAScore = 0.obs;
  @override
  RxInt teamBScore = 0.obs;
  @override
  RxInt teamACorners = 0.obs;
  @override
  RxInt teamBCorners = 0.obs;
  @override
  RxInt teamAFouls = 0.obs;
  @override
  RxInt teamBFouls = 0.obs;
  @override
  RxInt teamADefense = 0.obs;
  @override
  RxInt teamBDefense = 0.obs;
  @override
  RxInt teamAOffside = 0.obs;
  @override
  RxInt teamBOffside = 0.obs;
  @override
  RxInt teamAPasses = 0.obs;
  @override
  RxInt teamBPasses = 0.obs;
  @override
  RxInt teamAPossesion = 50.obs;
  @override
  RxInt teamBPossesion = 50.obs;
  @override
  RxInt teamAShots = 0.obs;
  @override
  RxInt teamBShots = 0.obs;
  @override
  RxInt teamAShotsGoal = 0.obs;
  @override
  RxInt teamBShotsGoal = 0.obs;
  @override
  RxInt teamAYellowCard = 0.obs;
  @override
  RxInt teamBYellowCard = 0.obs;
  @override
  RxInt teamARedCard = 0.obs;
  @override
  RxInt teamBRedCard = 0.obs;

  //FUNÇÃO PARA DEFINIR TIME ESPECIFICO DA PARTIDA
  void setTeam(TeamModel team, bool flag) {
    //VERIFICAR FLAG E DEFINIR EQUIPE
    if(flag){
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
  void setCurrentGame(GameModel game){
    //RESGATAR INSTANCIA DO CONTROLLER
    late final gameController = this as GameController;
    //DEFINIR PARTIDA ATUAL
    gameController.currentGame = game;
    //RESGATAR INFORMAÇÕES DA PARTIDA
    gameController.teamA = game.teams != null ? game.teams!.first : TeamModel(players: []);
    gameController.teamB = game.teams != null ? game.teams!.last : TeamModel(players: []);
    gameController.teamAlength = game.teams != null ? game.teams!.first.players.length.obs : 0.obs;
    gameController.teamBlength = game.teams != null ? game.teams!.last.players.length.obs : 0.obs;
    gameController.teamAScore = game.result != null ? game.result!.teamAScore.obs : 0.obs;
    gameController.teamBScore = game.result != null ? game.result!.teamBScore.obs : 0.obs;
  }

  //FUNÇÃO PARA DEFINIR CONFIGURAÇÕES DA PARTIDA (ANTES DE INICIAR)
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
      event : gameController.event,
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
    //DEFINIR VOTAÇÃO PARA EQUIPE VENCEDORA
    gameController.setVotesGame();
    //DEFINIR VOTAÇÃO PARA JOGADORES DA EQUIPE
    gameController.setVotesMVP();
    //GERAR EVENTOS FAKE DA PARTIDA/* Remover */
    List.generate(10, (i) => gameController.gameEvents.addIf(gameController.gameEvents.length < 11, gameEventService.generateGameEvent(
      i % 2 == 0 ? teamA : teamB,
      i % 2 == 0 ? teamA.players[0] : teamB.players[0],
    )));
    // ENCONTRAR ÍNDICE DO ITEM NA LISTA
    final index = gameController.nextGames.indexWhere((item) => item!.id == gameController.currentGame.id);
    //VERIFICAR SE FOI ENCONTRADO O INDEX DA PARTIDA
    if (index != -1) {
      //ATUALIZAR REGISTRO DE PARTIDA NA LISTA DE PROXIMAS PARTIDAS
      gameController.nextGames[index] = gameController.currentGame;
    }
  }
}

//===MIXIN - PARTIDAS===
mixin GameScheduleMixin on GetxController implements GameBase{
  //RESGATAR DATA DO DIA
  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //ESTADOS - PARTIDAS
  final loadGames = false.obs;
  final hasGames = true.obs;
  final loadHistoricGames = false.obs;
  //ESTADO - QTD CARDS VISIVEIS
  var qtdView = 3.obs; 
  //ESTADO - PARTIDAS (EM CURSO, PROXIMAS, AGENDADAS, FINALIZADAS)
  final RxList<GameModel?> inProgressGames = <GameModel?>[].obs;
  final RxList<GameModel?> nextGames = <GameModel?>[].obs;
  final RxList<GameModel?> scheduledGames = <GameModel?>[].obs;
  final RxMap<String, List<GameModel>?> finishedGames = <String, List<GameModel>?>{}.obs;

  //FUNÇÃO PARA VERIFICAR SE EVENTO É HOJE
  bool isToday(){
    return today.isAtSameMomentAs(eventDate!);
  }

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
    //RESGATAR CONTROLLER PRINCIPAL
    final id = GameController.instance.currentGame.id;
    //REGISTRAR STREMS DE CRONOMETRO
    final clockStream = timerService.clockStream(id);
    final elapsedStream = timerService.elapsedStream(id);
    //ESCUTAR LISTENERS DO CRONOMETRO
    GameController.instance._timeSubscription = rxdart.CombineLatestStream.combine2<String, int, void>(
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