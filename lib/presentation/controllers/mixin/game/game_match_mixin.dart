import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/result_model.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - PARTIDA ATUAL===
mixin GameMatchMixin on ChangeNotifier implements GameBase {
  //ESTADO - PARTIDA
  bool _isGameReady = false;
  @override
  bool get isGameReady => _isGameReady;
  set isGameReady(bool v) { _isGameReady = v; notifyListeners(); }

  @override
  TeamModel teamA = TeamModel(players: []);
  @override
  TeamModel teamB = TeamModel(players: []);

  final List<GameEventModel> _gameEvents = [];
  @override
  List<GameEventModel> get gameEvents => _gameEvents;

  int _teamAlength = 0;
  @override
  int get teamAlength => _teamAlength;
  set teamAlength(int v) { _teamAlength = v; notifyListeners(); }

  int _teamBlength = 0;
  @override
  int get teamBlength => _teamBlength;
  set teamBlength(int v) { _teamBlength = v; notifyListeners(); }

  int _teamAScore = 0;
  @override
  int get teamAScore => _teamAScore;
  set teamAScore(int v) { _teamAScore = v; notifyListeners(); }

  int _teamBScore = 0;
  @override
  int get teamBScore => _teamBScore;
  set teamBScore(int v) { _teamBScore = v; notifyListeners(); }

  int _teamACorners = 0;
  @override
  int get teamACorners => _teamACorners;
  set teamACorners(int v) { _teamACorners = v; notifyListeners(); }

  int _teamBCorners = 0;
  @override
  int get teamBCorners => _teamBCorners;
  set teamBCorners(int v) { _teamBCorners = v; notifyListeners(); }

  int _teamAFouls = 0;
  @override
  int get teamAFouls => _teamAFouls;
  set teamAFouls(int v) { _teamAFouls = v; notifyListeners(); }

  int _teamBFouls = 0;
  @override
  int get teamBFouls => _teamBFouls;
  set teamBFouls(int v) { _teamBFouls = v; notifyListeners(); }

  int _teamADefense = 0;
  @override
  int get teamADefense => _teamADefense;
  set teamADefense(int v) { _teamADefense = v; notifyListeners(); }

  int _teamBDefense = 0;
  @override
  int get teamBDefense => _teamBDefense;
  set teamBDefense(int v) { _teamBDefense = v; notifyListeners(); }

  int _teamAOffside = 0;
  @override
  int get teamAOffside => _teamAOffside;
  set teamAOffside(int v) { _teamAOffside = v; notifyListeners(); }

  int _teamBOffside = 0;
  @override
  int get teamBOffside => _teamBOffside;
  set teamBOffside(int v) { _teamBOffside = v; notifyListeners(); }

  int _teamAPasses = 0;
  @override
  int get teamAPasses => _teamAPasses;
  set teamAPasses(int v) { _teamAPasses = v; notifyListeners(); }

  int _teamBPasses = 0;
  @override
  int get teamBPasses => _teamBPasses;
  set teamBPasses(int v) { _teamBPasses = v; notifyListeners(); }

  int _teamAPossesion = 50;
  @override
  int get teamAPossesion => _teamAPossesion;
  set teamAPossesion(int v) { _teamAPossesion = v; notifyListeners(); }

  int _teamBPossesion = 50;
  @override
  int get teamBPossesion => _teamBPossesion;
  set teamBPossesion(int v) { _teamBPossesion = v; notifyListeners(); }

  int _teamAShots = 0;
  @override
  int get teamAShots => _teamAShots;
  set teamAShots(int v) { _teamAShots = v; notifyListeners(); }

  int _teamBShots = 0;
  @override
  int get teamBShots => _teamBShots;
  set teamBShots(int v) { _teamBShots = v; notifyListeners(); }

  int _teamAShotsGoal = 0;
  @override
  int get teamAShotsGoal => _teamAShotsGoal;
  set teamAShotsGoal(int v) { _teamAShotsGoal = v; notifyListeners(); }

  int _teamBShotsGoal = 0;
  @override
  int get teamBShotsGoal => _teamBShotsGoal;
  set teamBShotsGoal(int v) { _teamBShotsGoal = v; notifyListeners(); }

  int _teamAYellowCard = 0;
  @override
  int get teamAYellowCard => _teamAYellowCard;
  set teamAYellowCard(int v) { _teamAYellowCard = v; notifyListeners(); }

  int _teamBYellowCard = 0;
  @override
  int get teamBYellowCard => _teamBYellowCard;
  set teamBYellowCard(int v) { _teamBYellowCard = v; notifyListeners(); }

  int _teamARedCard = 0;
  @override
  int get teamARedCard => _teamARedCard;
  set teamARedCard(int v) { _teamARedCard = v; notifyListeners(); }

  int _teamBRedCard = 0;
  @override
  int get teamBRedCard => _teamBRedCard;
  set teamBRedCard(int v) { _teamBRedCard = v; notifyListeners(); }

  //FUNÇÃO PARA DEFINIR TIME ESPECIFICO DA PARTIDA
  void setTeam(TeamModel team, bool flag) {
    if (flag) {
      teamA = team;
    } else {
      teamB = team;
    }
    notifyListeners();
  }

  //FUNÇÃO PARA DEFINIR TIMES DA PARTIDA
  void setTeams(GameModel game) {
    game.teams = [teamA, teamB];
  }

  //FUNÇÃO PARA DEFINIR CONFIGURAÇÕES DA PARTIDA
  void setCurrentGame(GameModel game) {
    late final gameController = this as GameController;
    gameController.currentGame = game;
    gameController.teamA = game.teams != null ? game.teams!.first : TeamModel(players: []);
    gameController.teamB = game.teams != null ? game.teams!.last : TeamModel(players: []);
    gameController.teamAlength = game.teams != null ? game.teams!.first.players.length : 0;
    gameController.teamBlength = game.teams != null ? game.teams!.last.players.length : 0;
    gameController.teamAScore = game.result != null ? game.result!.teamAScore : 0;
    gameController.teamBScore = game.result != null ? game.result!.teamBScore : 0;
  }

  //FUNÇÃO PARA DEFINIR CONFIGURAÇÕES DA PARTIDA (ANTES DE INICIAR)
  void setGame() {
    GameController gameController = GameController.instance;
    int totalDuration = gameController.currentGameConfig!.config!["hasTwoHalves"]!
      ? int.parse(gameController.durationController.text) * 2
      : int.parse(gameController.durationController.text);

    final result = ResultModel(
      gameId: currentGame.id,
      teamA: teamA,
      teamB: teamB,
      teamAScore: teamAScore,
      teamBScore: teamBScore,
      duration: null
    );
    gameController.teamA = TeamModel(
      id: gameController.teamA.id,
      uuid: gameController.teamA.uuid,
      name: gameController.teamANameController.text,
      emblem: gameController.teamAEmblemaController.text,
      players: teamA.players,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    gameController.teamB = TeamModel(
      id: gameController.teamB.id,
      uuid: gameController.teamB.uuid,
      name: gameController.teamBNameController.text,
      emblem: gameController.teamBEmblemaController.text,
      players: teamB.players,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    gameController.currentGame = gameController.currentGame.copyWith(
      id: gameController.currentGame.id,
      number: gameController.currentGame.number,
      eventId: gameController.event.id,
      refereeId: gameController.refereerController!.id,
      duration: int.parse(gameController.durationController.text),
      startTime: DateFormat.Hm().parse(gameController.startTimeController.text),
      endTime: gameController.currentGame.startTime!.add(Duration(minutes: totalDuration)),
      status: gameController.currentGame.status,
      result: result,
      teams: [gameController.teamA, gameController.teamB],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    gameController.setVotesGame();
    gameController.setVotesMVP();
    final index = gameController.nextGames.indexWhere((item) => item!.id == gameController.currentGame.id);
    if (index != -1) {
      gameController.nextGames[index] = gameController.currentGame;
    }
    notifyListeners();
  }
}
