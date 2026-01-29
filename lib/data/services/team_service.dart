import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

class TeamService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  TeamModel generateTeam(int gameId, int i) {
    //DEFINIR NOME DE PARA EMBLEMA DA EQUIPE
    String emblem = "emblema_${faker.randomGenerator.integer(8, min: 1)}";
    //GERAR EQUIPE (TIME)
    return TeamModel.fromMap({
      "id": i,
      "gameId": gameId,
      "uuid": faker.jwt.secret.toString(),
      "name": "Time ${i + 1}",
      "emblem": emblem,
      "players": null,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //GERAR TIMES DO JOGO 
  List<dynamic> generateTeams(int gameId, int qtd){
    return List.generate(qtd, (i) => generateTeam(gameId, i + 1).toMap());
  }

  //FUNÇÃO DE DEFINIÇÃO DE EQUIPES (ORDEM ALEATORIA OU ORDENADA)
  Future<void> setPlayersTeams(bool random) async{
    await Future.delayed(const Duration(seconds: 2));
    //CONTROLLER - PARTIDA
    GameController gameController = GameController.instance;
    //RESGATAR PARTICIPANTES PRESENTES PARA COMPOR AS EQUIPES
    var players = gameController.participantsPresent.take(gameController.currentGameConfig!.playersPerTeam! * 2).toList();
    gameController.participantsPresent.removeRange(0, gameController.currentGameConfig!.playersPerTeam! * 2);
    //VERIFICAR SE FOI DEFINIDO EMBRALHAMENTO DE PARTICIPANTS
    if(random){
      //EMBARALHAR PARTICIPANTES COLETADOS
      players = [...players]..shuffle(Random());
    }
    //LIMPAR JOGADORES DAS EQUIPES
    gameController.teamA.players.clear();
    gameController.teamB.players.clear();
    //ADICIONAR JOGADORES AS EQUIPES
    gameController.teamA.players.addAll(players.take(gameController.currentGameConfig!.playersPerTeam!));
    gameController.teamB.players.addAll(players.skip(gameController.currentGameConfig!.playersPerTeam!).take(gameController.currentGameConfig!.playersPerTeam!));
    //ATUALIZAR ESTADO DE QTD DE JOGADORES POR EQUIEPE
    gameController.teamAlength.value = gameController.teamA.players.length;
    gameController.teamBlength.value = gameController.teamB.players.length;
  }
  
  //FUNÇÃO DE DEFINIÇÃO DE EQUIPES (ORDEM ALEATORIA OU ORDENADA)
  Future<void> setPlayersByTeam(TeamModel team) async{
    await Future.delayed(const Duration(seconds: 2));
    //CONTROLLER - PARTIDA
    GameController gameController = GameController.instance;
    //VERIFICAR QUAL EQUIPE DEVE SER REALOCADA
    if(team == gameController.teamA){
      //RETORNAR JOGADORES PARA A LISTA
      gameController.participantsPresent.addAll(gameController.teamA.players);
      gameController.teamA.players.clear();
      //RESGATAR PARTICIPANTES PRESENTES PARA COMPOR AS EQUIPES
      var players = gameController.participantsPresent.take(gameController.currentGameConfig!.playersPerTeam!).toList();
      gameController.participantsPresent.removeRange(0, gameController.currentGameConfig!.playersPerTeam!);
      //ATUALIZAR JOGADORES DA EQUIPE A
      gameController.teamA.players.addAll(players.take(gameController.currentGameConfig!.playersPerTeam!));
      gameController.teamAlength.value = gameController.teamA.players.length;
    }else{
      //RETORNAR JOGADORES PARA A LISTA
      gameController.participantsPresent.addAll(gameController.teamB.players);
      gameController.teamB.players.clear();
      //RESGATAR PARTICIPANTES PRESENTES PARA COMPOR AS EQUIPES
      var players = gameController.participantsPresent.take(gameController.currentGameConfig!.playersPerTeam!).toList();
      gameController.participantsPresent.removeRange(0, gameController.currentGameConfig!.playersPerTeam!);
      //ATUALIZAR JOGADORES DA EQUIPE A
      gameController.teamB.players.addAll(players.take(gameController.currentGameConfig!.playersPerTeam!));
      gameController.teamBlength.value = gameController.teamB.players.length;
    }
  }

  //FUNÇÃO DE RESET DE EQUIPES
  Future<bool> resetPlayersTeams() async{
    await Future.delayed(const Duration(seconds: 2));
    //CONTROLLER - PARTIDA
    GameController gameController = GameController.instance;
    //RETORNAR JOGADORES PARA A LISTA
    gameController.participantsPresent.addAll(gameController.teamA.players);
    gameController.participantsPresent.addAll(gameController.teamB.players);
    //LIMPAR JOGADORES DAS EQUIPES
    gameController.teamA.players.clear();
    gameController.teamB.players.clear();
    //ATUALIZAR ESTADO DE QTD DE JOGADORES POR EQUIEPE
    gameController.teamAlength.value = gameController.teamA.players.length;
    gameController.teamBlength.value = gameController.teamB.players.length;
    //RETURN PARA VERIFICAR SE TODOS JOGADORES FORAM ALOCADOS
    return true;
  }
}