import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/game_config_model.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/services/game_service.dart';
import 'package:futzada/data/services/team_service.dart';
import 'package:futzada/data/services/timer_service.dart';
import 'package:futzada/data/services/game_stream_service.dart';
import 'package:futzada/data/services/game_event_service.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_stream_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_config_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_day_event_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_match_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_schedule_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_stopwatch_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_vote_mixin.dart';

//===DEPENDENCIAS BASE===
abstract class GameBase {
  //GETTER - SERVIÇOS
  GameService get gameService;
  GameEventService get gameEventService;
  TimerService get timerService;
  TeamService get teamService;
  //GETTER - EVENTO
  EventModel? get event;
  //GETTER - CONFIGURAÇÕES DAS PARTIDAS
  GameConfigModel? get currentGameConfig;
  //ESTADO PARTIDA
  GameModel get currentGame;

  //===DIA DE PARTIDA===
  List<UserModel> get participantsClone;
  List<UserModel> get participantsPresent;
  Map<String, double> get votesGame;
  Map<String, int>? get votesMVP;
  int get votesGameCount;
  int get votesMVPCount;

  //===PARTIDA===
  //ESTADO - EQUIPES DA PARTIDA
  bool get isGameReady;
  TeamModel get teamA;
  TeamModel get teamB;
  //ESTADO - QUANTIDADE DE JOGADORES NAS EQUIPES NA PARTIDA
  int get teamAlength;
  set teamAlength(int v);
  int get teamBlength;
  set teamBlength(int v);
  //ESTADO - PLACAR EQUIPES NA PARTIDA
  int get teamAScore;
  set teamAScore(int v);
  int get teamBScore;
  set teamBScore(int v);
  //ESTADO - ESTATISTICAS DA PARTIDA
  int get teamACorners;
  set teamACorners(int v);
  int get teamBCorners;
  set teamBCorners(int v);
  int get teamAFouls;
  set teamAFouls(int v);
  int get teamBFouls;
  set teamBFouls(int v);
  int get teamADefense;
  set teamADefense(int v);
  int get teamBDefense;
  set teamBDefense(int v);
  int get teamAOffside;
  set teamAOffside(int v);
  int get teamBOffside;
  set teamBOffside(int v);
  int get teamAPasses;
  set teamAPasses(int v);
  int get teamBPasses;
  set teamBPasses(int v);
  int get teamAPossesion;
  set teamAPossesion(int v);
  int get teamBPossesion;
  set teamBPossesion(int v);
  int get teamAShots;
  set teamAShots(int v);
  int get teamBShots;
  set teamBShots(int v);
  int get teamAShotsGoal;
  set teamAShotsGoal(int v);
  int get teamBShotsGoal;
  set teamBShotsGoal(int v);
  int get teamAYellowCard;
  set teamAYellowCard(int v);
  int get teamBYellowCard;
  set teamBYellowCard(int v);
  int get teamARedCard;
  set teamARedCard(int v);
  int get teamBRedCard;
  set teamBRedCard(int v);
  //ESTADO LISTA DE EVENTOS DA PARTIDA
  List<GameEventModel> get gameEvents;

  //===PARTIDA AO VIVO===
  //ESTADO - HORARIO DA PARTIDA, MINUTOS DA PARTIDA, MINUTOS DA FALTANTES, STATUS DA PARTIDA
  String get currentTime;
  int get minutesElapsed;
  int get remainingElapsed;
  bool get isGameRunning;
  set isGameRunning(bool v);

  //ESTADO - DIA DO EVENTO
  DateTime? get eventDate;

  //===CRONOMETRO===
  //STREAM - CRONOMETRO
  StreamSubscription<dynamic> get timeSubscription;
}

class GameController extends ChangeNotifier
  with GameConfigMixin, GameDayEventMixin, GameScheduleMixin, GameMatchMixin, GameVotesMixin, GameStopwatchMixin, GameStreamMixin {
  //GETTER DE CONTROLLERS
  static GameController get instance => sl<GameController>();

  //STREAM - CRONOMETRO
  @override
  late StreamSubscription<dynamic> timeSubscription;

  //GETTER - SERVIÇOS
  @override
  GameService gameService = GameService();
  @override
  GameStreamService streamService = GameStreamService();
  @override
  GameEventService gameEventService = GameEventService();
  @override
  TimerService timerService = TimerService();
  @override
  TeamService teamService = TeamService();

  //GETTER - ESTADOS
  @override
  late EventModel event;
  @override
  late GameModel currentGame;
  @override
  late DateTime? eventDate;
  @override
  late GameConfigModel? currentGameConfig;

  void init() {
    eventDate = DateFormat("dd/MM/yyyy").parse("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    streamService.init();
  }

  @override
  void dispose() {
    timeSubscription.cancel();
    disposeTextControllers();
    for (final game in inProgressGames) {
      if (game != null) {
        timerService.stopStopwatch(game.id);
      }
    }
    timerService.stopStopwatch(currentGame.id);
    super.dispose();
  }
}
