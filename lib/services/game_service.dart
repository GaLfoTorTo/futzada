import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/services/result_service.dart';
import 'package:futzada/services/team_service.dart';
import 'package:futzada/services/participant_service.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/event_model.dart';

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
    //GERAR TIMES DA PARTIDA
    var teams = teamService.generateTeams(event, 2);
    //GERAR JOGO (PARTIDA)
    return GameModel.fromMap({
      "id": i,
      "number": i,
      "referee": participantService.generateParticipant(1, hasRole: false).toMap(),
      "duration": random.nextInt(10),
      "startTime": DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
      "endTime": DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
      "status": setStatus(random.nextInt(3)),
      "result": resultService.generateResult(teams).toMap(),
      "teams": teams,
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAR CONFIGURAÇÕES DE PARTIDA
  GameConfigModel generateGameConfig(int i){
    //DEFINIR CATEGORIA
    String category = getCategory();
    //GERAR JOGO (PARTIDA)
    return GameConfigModel.fromMap({
      "id": i,
      "category" : category,
      "duration" : random.nextInt(10),
      "hasTwoHalves" : random.nextBool(),
      "hasExtraTime" : random.nextBool(),
      "hasPenalty" : random.nextBool(),
      "hasGoalLimit" : random.nextBool(),
      "hasRefereer" : random.nextBool(),
      "playersPerTeam" : getQtdPlayers(category)['qtdPlayers'],
      "extraTime" : random.nextInt(15),
      "goalLimit" : random.nextInt(5),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAR PARTIDAS PRÉ PROGRAMADAS AUTOMATICAMENTE
  List<GameModel?>getScheduledGames(EventModel event, int duration){
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
      totalGames = 1;
    }
    //GERAR LISTA DE PARTIDAS PRÉ PROGRAMADAS
    return List.generate(totalGames, (i) {
      //CALCULAR HORARIO DE INICIO E FIM DA PARTIDA
      DateTime startGame = timeStart.add(Duration(minutes: i * duration));
      DateTime endGame = startGame.add(Duration(minutes: duration));
      //GERAR TIMES DA PARTIDA
      var teams = teamService.generateTeams(event, 2);
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
        "teams": teams,
        "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
        "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2026).toString()),
      });
    });
  }
  
  //FUNÇÃO PARA GERAR PARTIDAS PRÉ PROGRAMADAS AUTOMATICAMENTE
  List<GameModel?>getHistoricGames(EventModel event){
    var duration = random.nextInt(10);
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
      totalGames = 1;
    }
    //GERAR HISTÓRICO DE PARTIDAS
    return List.generate(totalGames, (i) {
      //CALCULAR HORARIO DE INICIO E FIM DA PARTIDA
      DateTime startGame = timeStart.add(Duration(minutes: i * duration));
      DateTime endGame = startGame.add(Duration(minutes: duration));
      //GERAR TIMES DO JOGO 
      List<Map<String, dynamic>> teams = List.generate(2, (i){
        var team = teamService.generateTeam(event, i + 1, true);
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

  //FUNÇÃO PARA RESGATAR CATEGORIA DO EVENTO
  String getCategory(){
    int num = random.nextInt(3);
    switch (num) {
      case 1:
        return "Futebol";
      case 2:
        return "Fut7";
      case 3:
        return "Futsal";
      default:
        return "Fut7";
    }
  }

  //FUNÇÃO PARA DEFINIÇÃO DE QUANTIDADE DE JOGADORES POR CATEGORIA
  Map<String, int> getQtdPlayers(String category){
    //SELECIONAR TIPO DE CAMPO
    switch (category) {
      case "Futebol":
        //DEFINIR VALOR PARA SLIDER
        return {
          "qtdPlayers" : 11,
          "minPlayers" :  9,
          "maxPlayers" : 11,
          "divisions" : 2,
        };
      case "Fut7":
        //DEFINIR VALOR PARA SLIDER
        return {
          "qtdPlayers" : 4,
          "minPlayers" :  4,
          "maxPlayers" : 8,
          "divisions" : 4,
        };
      case "Futsal":
        //DEFINIR VALOR PARA SLIDER
        return {
          "qtdPlayers" : 5,
          "minPlayers" :  4,
          "maxPlayers" : 16,
          "divisions" : 2,
        };
      default:
      //DEFINIR VALOR PARA SLIDER
        return {
          "qtdPlayers" : 11,
          "minPlayers" :  9,
          "maxPlayers" : 11,
          "divisions" : 2,
        };
    }
  }
}