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
  GameModel generateGame(int i, EventModel event) {
    //GERAR TIMES DO JOGO 
    List<TeamModel> teams = List.generate(2, (i){
      return teamService.generateTeam(i + 1, event);
    });
    //GERAR JOGO (PARTIDA)
    return GameModel.fromMap({
      'id': i,
      'number': i,
      'referee': participantService.generateParticipant(1, hasRole: false).toMap(),
      'duration': random.nextInt(10),
      'startTime': "${random.nextInt(17 - 20)}:${random.nextInt(00 - 59)}",
      'endTime': "${random.nextInt(17 - 20)}:${random.nextInt(00 - 59)}",
      'status': setStatus(random.nextInt(3)),
      'result': resultService.generateResult(teams).toMap(),
      'teams': teams,
      "createdAt" : DateFormat('dd/MM/yyyy HH:ii:ss').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      "updatedAt" : DateFormat('dd/MM/yyyy HH:ii:ss').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
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
  GameModel?  getNextGame(EventModel event, GameModel? lastGame){
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