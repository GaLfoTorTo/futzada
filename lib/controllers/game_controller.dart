import 'dart:async';
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
  
  //GETTER DE EVENTO E PARTIDA ATUAL
  @override
  late EventModel event;
  @override
  late GameModel currentGame;
  @override
  late DateTime? eventDate;

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
  GameModel setGame({GameModel? newGame}) {
    //VERIFICAR SE FOI RECEBIDO OBJETO DE PARTIDA
    if (newGame != null) {
      return newGame;
    }
    //GERAR RESULTADO DA PARTIDA
    final result = ResultModel(
      teamA: teamA, 
      teamB: teamB, 
      teamAScore: teamAScore.value, 
      teamBScore: teamBScore.value, 
      duration: null
    );
    //RETORNAR PARTIDA COM MODIFICAÇÕES DO USUARIO
    return currentGame.copyWith(
      duration: currentGameConfig!.duration,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(minutes: currentGameConfig!.duration!)),
      status: currentGame.status,
      result: result,
      teams: [teamA, teamB],
      updatedAt: DateTime.now(),
    );
  }
}

//===MIXIN - CONFIGURAÇÕES DAS PARTIDAS===
mixin GameConfigMixin on GetxController implements GameBase{
  //ESTADO - CONFIGURAÇÕES DE PARTIDA
  @override
  GameConfigModel? currentGameConfig;

  //FUNÇÃO DE DEFINIÇÃO DE CONFIGURAÇÕES DA PARTIDA
  void setGameConfig({GameConfigModel? gameConfig}) {
    currentGameConfig = gameConfig ?? event!.gameConfig;
  }

  //FUNÇÃO DE SALVAMENTO DE CONFIGURAÇÕES DA PARTIDA
  void saveGameConfig() {
    event!.gameConfig = currentGameConfig;
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