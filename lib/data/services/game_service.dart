import 'dart:math';
import 'package:futzada/core/helpers/modality_helper.dart';
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
  GameConfigModel generateGameConfig(int eventId, String modality){
    //DEFINIR CATEGORIA
    String category = ModalityHelper.getCategory(modality, faker.randomGenerator.integer(2));
    //GERAR JOGO (PARTIDA)
    return GameConfigModel.fromMap({
      "id": faker.randomGenerator.integer(100, min: 1),
      "eventId": eventId,
      "duration" : random.nextInt(10),
      "category" : category,
      "playersPerTeam" : ModalityHelper.getQtdPlayers(category)['qtdPlayers'],
      "points" : generateLimitPoints(modality),
      "refereerId" : random.nextInt(30),
      "config" : generateExtraGameConfig(modality),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2025, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAR CONFIGURAÇÕES DA PARTIDA A PARTIR DA MODALIDADE
  Map<String, dynamic> generateExtraGameConfig(String modality){
    switch (modality) {
      case "Volleyball":
        return {
          "sets" : faker.randomGenerator.integer(3, min: 1),
          "tieBreakPoints" : faker.randomGenerator.integer(15, min: 3),
        };
      case "Basketball":
        return {
          "quarters" : faker.randomGenerator.integer(4, min: 1),
          "shotClock" : faker.randomGenerator.integer(60, min: 30),
        };
      default:
        return {
          "halves" : faker.randomGenerator.integer(2, min: 1),
          "penalty" : random.nextBool()
        }; 
    }
  }

  int? generateLimitPoints(modality){
    return modality == "Volleyball" 
      ? faker.randomGenerator.integer(25, min: 10)
      : random.nextInt(100);
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
}