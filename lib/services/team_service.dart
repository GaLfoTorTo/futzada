import 'dart:math';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/team_model.dart';

class TeamService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  TeamModel generateTeam(int i, EventModel event) {
    //GERAR EQUIPE (TIME)
    return TeamModel.fromMap({
      "id": i,
      "uuid": i,
      "name": "Time ${i + 1}",
      "players": setPlayersTeam(event.participants!, event.qtdPlayers!),
      "createdAt" : DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      "updatedAt" : DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
    });
  }

  //GERAR JOGADORES DO TIME
  List<ParticipantModel> setPlayersTeam(List<ParticipantModel> participants, int qtd) {
    //DEFINIR LISTA DE JOGADORES
    List<ParticipantModel> players = [];
    int indexPlayer = 0;
    //LOOP PARA GERAR JOGADORES
    List.generate(qtd, (i) {
      //GERAR ÍNDICE ALEATÓRIO DE PARTICIPANTE
      int newIndexPlayer = random.nextInt(participants.length);
      indexPlayer = indexPlayer == newIndexPlayer ? (newIndexPlayer + 1) % participants.length : newIndexPlayer;
      //ADICIONAR JOGADOR A LISTA
      players.add(
        participants[indexPlayer]
      );
    });
    return players;
  }

  //FUNÇÃO PARA GERAR TIMES DA PARTIDA
  List<TeamModel> getTeams(int qtd, EventModel event) {
    //DEFINIR LISTA DE TIMES
    List<TeamModel> teams = [];
    //LOOP PARA GERAR TIMES
    List.generate(qtd, (i) {
      //ADICIONAR TIME A LISTA
      teams.add(
        generateTeam(i, event)
      );
    });
    return teams;
  }
}