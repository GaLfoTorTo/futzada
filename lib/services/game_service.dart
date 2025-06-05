import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/services/result_service.dart';
import 'package:futzada/services/team_service.dart';
import 'package:futzada/services/participant_service.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/team_model.dart';

class GameService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  ResultService resultService = ResultService();
  //INSTANCIAR SERVIÇO DE PARTICIPANTES
  ParticipantService participantService = ParticipantService();
  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  TeamService teamService = TeamService();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  GameModel generateGame(int i, EventModel event){
    //CALCULAR HORARIO DE INICIO E FIM DA PARTIDA
    var startGame = DateFormat('HH:mm').parse("${random.nextInt(21)}:${random.nextInt(30)}");
    var endGame = DateFormat('HH:mm').parse("${random.nextInt(21)}:${random.nextInt(30)}");
    //GERAR TIMES DA PARTIDA
    var teams = teamService.generateTeams(event, 2);
    //GERAR JOGO (PARTIDA)
    return GameModel.fromMap({
      "id": i,
      "number": i,
      "referee": participantService.generateParticipant(1, hasRole: false).toMap(),
      "duration": random.nextInt(10),
      "startTime": "${startGame.hour.toString().padLeft(2, '0')}:${startGame.minute.toString().padLeft(2, '0')}",
      "endTime": "${endGame.hour.toString().padLeft(2, '0')}:${endGame.minute.toString().padLeft(2, '0')}",
      "status": setStatus(random.nextInt(3)),
      "result": resultService.generateResult(teams).toMap(),
      "teams": teams,
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
    });
  }

  //FUNÇÃO PARA GERAR PARTIDAS PRÉ PROGRAMADAS AUTOMATICAMENTE
  List<GameModel?>getProgramaticGames(EventModel event, int duration){
    //RESGATAR INICIO E FIM DO DIA DE EVENTO
    DateTime timeStart = DateFormat("HH:mm").parse("${event.startTime}");
    DateTime timeEnd = DateFormat("HH:mm").parse("${event.endTime}");
    //CONTABILIZAR QUANTOS MINUTOS TEM DURANTE O PERIODO DE VENTO 
    int totalMinutes = timeEnd.difference(timeStart).inMinutes;
    //CALCULAR QUANTAS PARTIDAS CABEM NO PERIODO DE VENTO
    int totalGames = (totalMinutes / duration).floor();
    //VERIFICAR SE TOTAL DE PARTIDAS É MENOR QUE 1
    if (totalGames < 1) {
      //RETORNAR LISTA VAZIA
      return [];
    }
    //GERAR LISTA DE PARTIDAS PRÉ PROGRAMADAS
    return List.generate(totalGames, (i) {
      //CALCULAR HORARIO DE INICIO E FIM DA PARTIDA
      var calcStartGame = timeStart.add(Duration(minutes: i * duration));
      var calcEndGame = calcStartGame.add(Duration(minutes: duration));
      String startGame = DateFormat('HH:mm').format(calcStartGame);
      String endGame = DateFormat('HH:mm').format(calcEndGame);
      //GERAR PARTIDA PRÉ PROGRAMADA
      return GameModel.fromMap({
        "id": i + 1,
        "number": i + 1,
        "referee": participantService.generateParticipant(1, hasRole: false).toMap(),
        "duration": duration,
        "startTime": startGame,
        "endTime": endGame,
        "status": GameStatus.Scheduled,
        "result": null,
        "teams": [],
        "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
        "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
      });
    });
  }
  
  //FUNÇÃO PARA GERAR PARTIDAS PRÉ PROGRAMADAS AUTOMATICAMENTE
  List<GameModel?>getHistoricGames(EventModel event, int duration){
    //RESGATAR INICIO E FIM DO DIA DE EVENTO
    DateTime timeStart = DateFormat("HH:mm").parse("${event.startTime}");
    DateTime timeEnd = DateFormat("HH:mm").parse("${event.endTime}");
    //CONTABILIZAR QUANTOS MINUTOS TEM DURANTE O PERIODO DE VENTO 
    int totalMinutes = timeEnd.difference(timeStart).inMinutes;
    //CALCULAR QUANTAS PARTIDAS CABEM NO PERIODO DE VENTO
    int totalGames = (totalMinutes / duration).floor();
    //VERIFICAR SE TOTAL DE PARTIDAS É MENOR QUE 1
    if (totalGames < 1) {
      //RETORNAR LISTA VAZIA
      return [];
    }
    //GERAR HISTÓRICO DE PARTIDAS
    return List.generate(totalGames, (i) {
      //CALCULAR HORARIO DE INICIO E FIM DA PARTIDA
      var calcStartGame = timeStart.add(Duration(minutes: i * duration));
      var calcEndGame = calcStartGame.add(Duration(minutes: duration));
      String startGame = DateFormat('HH:mm').format(calcStartGame);
      String endGame = DateFormat('HH:mm').format(calcEndGame);
      //GERAR TIMES DO JOGO 
      List<Map<String, dynamic>> teams = List.generate(2, (i){
        var team = teamService.generateTeam(i + 1, event);
        return team.toMap();
      });
      //GERAR PARTIDA PRÉ PROGRAMADA
      return GameModel.fromMap({
        'id': i + 1,
        'number': i + 1,
        'referee': participantService.generateParticipant(1, hasRole: false).toMap(),
        'duration': duration,
        'startTime': startGame,
        'endTime': endGame,
        'status': GameStatus.Scheduled,
        'result': resultService.generateResult(teams).toMap(),
        'teams': teams,
        "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
        "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
      });
    });
  }

  //FUNÇÃO PARA BUSCAR PARTIDA SELECIONADO
  GameModel? getCurrentGame(EventModel event, int id) {
    //VERIFICAR SE EVENTOS TEM JOGOS
    if (event.games == null || event.games!.isEmpty) {
      //RESGATAR JOGO ATUAL
      return event.games!.firstWhere((game) => game.id == id);
    }
  }
  
  //FUNÇÃO PARA GERAR PROXIMAS PARTIDAS
  GameModel? getNextGame(EventModel event, GameModel? lastGame){
    //VERIFICAR SE EVENTOS TEM JOGOS
    if(event.games == null || event.games!.isEmpty){
      //VERIFICAR SE ÚLTIMO JOGO É NULO
      if(lastGame == null){
        //GERAR PROXIMO JOGO
        return generateGame(1, event);
      }
      //RESGATAR JOGO ATUAL
      return event.games!.firstWhere((game){
        //CONVERTER HORARIOS DE FIM DA PARTIDA ATUAL
        DateTime lastGameEndTime = DateFormat('HH:mm').parse(lastGame.endTime!);
        //CONVERTER HORARIOS DE INICIO DA PROXIMA PARTIDA
        DateTime nextGameStartTime = DateFormat('HH:mm').parse(game.startTime!);
        //VERIFICAR SE HORARIO DE INICIO DA PROXIMA PARTIDA É MAIOR OU IGUAL AO HORARIO DE FIM DA PARTIDA ATUAL
        return nextGameStartTime.isAfter(lastGameEndTime);
      });
    }
  }
  
  //FUNÇÃO PARA GERAR STATUS DE PARTICIPANTE DA PELADA
  static GameStatus setStatus(int i){
    switch (i) {
      case 0:
        return GameStatus.Scheduled;
      case 1:
        return GameStatus.In_progress;
      case 2:
        return GameStatus.Cancelled;
      case 3:
        return GameStatus.Completed;
      default:
        return GameStatus.Completed;
    }
  }
}