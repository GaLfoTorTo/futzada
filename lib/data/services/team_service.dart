import 'dart:math';
import 'package:faker/faker.dart';
import 'package:esportly/data/models/team_model.dart';

class TeamService {
  static var faker = Faker();
  static var random = Random();

  TeamModel generateTeam(int gameId, int i) {
    String emblem = "emblema_${faker.randomGenerator.integer(8, min: 1)}";
    return TeamModel.fromMap({
      "id": i,
      "gameId": gameId,
      "uuid": faker.jwt.secret.toString(),
      "name": "Time ${i + 1}",
      "emblem": emblem,
      "players": null,
      "createdAt": faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt": faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  List<dynamic> generateTeams(int gameId, int qtd) {
    return List.generate(qtd, (i) => generateTeam(gameId, i + 1).toMap());
  }
}