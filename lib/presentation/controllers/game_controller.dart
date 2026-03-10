import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:futzada/data/services/game_event_service.dart';
import 'package:futzada/data/services/team_service.dart';
import 'package:futzada/data/services/game_service.dart';
import 'package:futzada/data/services/timer_service.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/game_config_model.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_config_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_day_event_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_match_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_schedule_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_stopwatch_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/game/game_vote_mixin.dart';

//===DEPENDENCIAS BASE===
abstract class GameBase {
  //GETTER - SERVIÇOS PARTIDAS, EQUIPES, CRONOMETRO
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
  List<UserModel>? get participantsClone;
  RxList<UserModel>? get participantsPresent;
  RxMap<String, double> get votesGame;
  RxMap<String, int>? get votesMVP;
  RxInt get votesGameCount;
  RxInt get votesMVPCount;
  
  //===PARTIDA===
  //ESTADO - EQUIPES DA PARTIDA
  RxBool get isGameReady;
  TeamModel get teamA;
  TeamModel get teamB;
  //ESTADO - QUANTIDADE DE JOGADORES NAS EQUIPES NA PARTIDA
  RxInt get teamAlength;
  RxInt get teamBlength;
  //ESTADO - PLACAR EQUIPES NA PARTIDA
  RxInt get teamAScore;
  RxInt get teamBScore;
  //ESTADO - ESTATISTICAS DA PARTIDA
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
  //ESTADO - HORARIO DA PARTIDA, MINUTOS DA PARTIDA, MINUTOS DA FALTANTES, STATUS DA PARTIDA
  RxString get currentTime;
  RxInt get minutesElapsed;
  RxInt get remainingElapsed;
  RxBool get isGameRunning;

  //ESTADO - DIA DO EVENTO
  DateTime? get eventDate;

  //===CRONOMETRO===
  //STREAM - CRONOMETRO
  StreamSubscription<dynamic> get timeSubscription;
}

class GameController extends GetxController
  with GameConfigMixin, GameDayEventMixin, GameScheduleMixin, GameMatchMixin, GameVotesMixin, GameStopwatchMixin{
  //GETTER DE CONTROLLERS
  static GameController get instance => Get.find();
  
  //STREAM - CRONOMETRO
  @override
  late StreamSubscription<dynamic> timeSubscription;

  //GETTER - SERVIÇOS
  @override
  GameService gameService = GameService();
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
    timeSubscription.cancel();
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