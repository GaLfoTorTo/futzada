import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/game_config_model.dart';
import 'package:futzada/data/services/result_service.dart';
import 'package:futzada/data/services/team_service.dart';
import 'package:futzada/data/services/participant_service.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/event_model.dart';

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
    var teams = teamService.generateTeams(i, 2);
    //GERAR JOGO (PARTIDA)
    return GameModel.fromMap({
      "id": i,
      "number": i,
      "eventId": i,
      "refereeId": event.participants![random.nextInt(event.participants!.length)].id,
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
      "eventId": i,
      "duration" : random.nextInt(10),
      "category" : category,
      "playersPerTeam" : getQtdPlayers(category)['qtdPlayers'],
      "config" : {
        "hasTwoHalves" : random.nextBool(),
        "hasExtraTime" : random.nextBool(),
        "hasPenalty" : random.nextBool(),
        "hasGoalLimit" : random.nextBool(),
        "hasRefereer" : random.nextBool(),
        "extraTime" : random.nextInt(15),
        "goalLimit" : random.nextInt(5),
      },
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAR PARTIDAS PRÉ PROGRAMADAS AUTOMATICAMENTE
  List<GameModel?>getListGames(EventModel event){
    //RESGATAR DURAÇÃO DA PARTIDA
    int duration = event.gameConfig!.duration!;
    //RESGATAR INICIO E FIM DO DIA DE EVENTO
    DateTime timeStart = DateFormat("HH:mm").parse("${event.startTime}");
    DateTime timeEnd = DateFormat("HH:mm").parse("${event.endTime}");
    //CALCULAR QUANTAS PARTIDAS CABEM NO PERIODO DE EVENTO
    int totalMinutes = timeEnd.difference(timeStart).inMinutes;
    int qtdGames = (totalMinutes / duration).floor();
    int totalGames = qtdGames > 1 ? qtdGames : random.nextInt(10);
    //GERAR LISTA DE PARTIDAS
    return List.generate(totalGames, (i) {
      //CALCULAR HORARIO DE INICIO E FIM DA PARTIDA
      DateTime startGame = timeStart.add(Duration(minutes: i * duration));
      DateTime endGame = startGame.add(Duration(minutes: duration));
      var id = i + 1;
      //GERAR PARTIDA PRÉ PROGRAMADA
      return GameModel.fromMap({
        "id": id,
        "number": i + 1,
        "eventId" : event.id,
        "refereeId": event.participants![random.nextInt(event.participants!.length)].id,
        "duration": duration,
        "startTime": startGame,
        "endTime": endGame,
        "status": GameStatus.Scheduled,
        "result": null,
        "teams": teamService.generateTeams(id, 2),
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
        return "Futebol";
    }
  }

  //FUNÇÃO PARA DEFINIÇÃO DE QUANTIDADE DE JOGADORES POR CATEGORIA
  Map<String, int> getQtdPlayers(String category){
    //SELECIONAR TIPO DE CAMPO
    switch (category) {
      //DEFINIR VALOR PARA SLIDER
      case "Futebol":
        return {
          "qtdPlayers" : 11,
          "minPlayers" :  9,
          "maxPlayers" : 11,
          "divisions" : 2,
        };
      case "Fut7":
        return {
          "qtdPlayers" : 4,
          "minPlayers" :  4,
          "maxPlayers" : 8,
          "divisions" : 4,
        };
      case "Futsal":
        return {
          "qtdPlayers" : 5,
          "minPlayers" :  4,
          "maxPlayers" : 6,
          "divisions" : 2,
        };
      default:
        return {
          "qtdPlayers" : 11,
          "minPlayers" :  9,
          "maxPlayers" : 11,
          "divisions" : 2,
        };
    }
  }
}