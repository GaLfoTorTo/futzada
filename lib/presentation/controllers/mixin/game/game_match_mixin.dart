import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/result_model.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - PARTIDA ATUAL===
mixin GameMatchMixin on GetxController implements GameBase{
  //ESTADO - PARTIDA
  @override
  RxBool isGameReady = false.obs;
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
    int totalDuration = gameController.currentGameConfig!.config!["hasTwoHalves"]! 
      ? int.parse(gameController.durationController.text) * 2 
      : int.parse(gameController.durationController.text);

    //INICIALIZAR RESULTADO DA PARTIDA
    final result = ResultModel(
      gameId: currentGame.id,
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
      emblem: gameController.teamAEmblemaController.text,
      players: teamA.players,
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
    gameController.teamB = TeamModel(
      id: gameController.teamB.id,
      uuid: gameController.teamB.uuid,
      name: gameController.teamBNameController.text,
      emblem: gameController.teamBEmblemaController.text,
      players: teamB.players,
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
    //ATUALIZAR PARTIDA ATUAL
    gameController.currentGame = gameController.currentGame.copyWith(
      id : gameController.currentGame.id,
      number : gameController.currentGame.number,
      eventId : gameController.event.id,
      refereeId : gameController.refereerController!.id,
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
    /* List.generate(10, (i) => gameController.gameEvents.addIf(gameController.gameEvents.length < 11, gameEventService.generateGameEvent(
      i % 2 == 0 ? teamA : teamB,
      i % 2 == 0 ? teamA.players[0] : teamB.players[0],
    ))); */
    // ENCONTRAR ÍNDICE DO ITEM NA LISTA
    final index = gameController.nextGames.indexWhere((item) => item!.id == gameController.currentGame.id);
    //VERIFICAR SE FOI ENCONTRADO O INDEX DA PARTIDA
    if (index != -1) {
      //ATUALIZAR REGISTRO DE PARTIDA NA LISTA DE PROXIMAS PARTIDAS
      gameController.nextGames[index] = gameController.currentGame;
    }
  }
}