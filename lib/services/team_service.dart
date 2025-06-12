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
    //GERAR NUMERO ALEATORIO PARA INDEX DE EMBLEMA
    int index = Random().nextInt(8);
    //DEFINIR NOME DE PARA EMBLEMA DA EQUIPE
    String emblema = "emblema_${index == 0 ? 1 : index}";
    //GERAR EQUIPE (TIME)
    return TeamModel.fromMap({
      "id": i,
      "uuid": "$i",
      "name": "Time ${i + 1}",
      "emblema": emblema,
      "players": event.gameConfig != null ? setPlayersTeam(event.participants!, event.gameConfig!.playersPerTeam!) : [],
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }

  //GERAR TIMES DO JOGO 
  List<dynamic> generateTeams(event, qtd){
    var teams = [];
    List.generate(qtd, (i){
      teams.add(generateTeam(i + 1, event).toMap());
    });
    return teams;
  }

  //GERAR JOGADORES DO TIME
  List<Map<String, dynamic>> setPlayersTeam(List<ParticipantModel> participants, int qtd) {
    //DEFINIR LISTA DE JOGADORES
    List<Map<String, dynamic>> players = [];
    int indexPlayer = 0;
    //LOOP PARA GERAR JOGADORES
    List.generate(qtd, (i) {
      //GERAR ÍNDICE ALEATÓRIO DE PARTICIPANTE
      int newIndexPlayer = random.nextInt(participants.length);
      indexPlayer = indexPlayer == newIndexPlayer ? (newIndexPlayer + 1) % participants.length : newIndexPlayer;
      //ADICIONAR JOGADOR A LISTA
      players.add(
        participants[indexPlayer].toMap()
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