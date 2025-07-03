import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/models/team_model.dart';

class TeamService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  TeamModel generateTeam(EventModel event, int i, bool? setPlayers) {
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
      "players": setPlayers != null && setPlayers ? setPlayersTeam(event.participants!, event.gameConfig!.playersPerTeam!) : null,
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }

  //GERAR TIMES DO JOGO 
  List<dynamic> generateTeams(EventModel event, int qtd, {bool? setPlayers}){
    var teams = [];
    List.generate(qtd, (i){
      teams.add(generateTeam(event, i + 1, setPlayers).toMap());
    });
    return teams;
  }

  //FUNÇÃO PARA GERAR TIMES DA PARTIDA
  List<TeamModel> getTeams(int qtd, EventModel event) {
    //DEFINIR LISTA DE TIMES
    List<TeamModel> teams = [];
    //LOOP PARA GERAR TIMES
    List.generate(qtd, (i) {
      //ADICIONAR TIME A LISTA
      teams.add(
        generateTeam(event, i, false)
      );
    });
    return teams;
  }

  //GERAR JOGADORES DO TIME
  List<Map<String, dynamic>> setPlayersTeam(List<ParticipantModel> participants, int qtd) {
    //DEFINIR LISTA DE JOGADORES
    List<Map<String, dynamic>> players = [];
    //LOOP PARA GERAR JOGADORES
    List.generate(qtd, (i) {
      //ADICIONAR JOGADOR A LISTA
      players.add(
        participants[i].toMap()
      );
    });
    return players;
  }
}