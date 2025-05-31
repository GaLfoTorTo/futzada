import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/result_model.dart';

class ResultService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  ResultModel generateResult(List<TeamModel> teams){
    return ResultModel.fromMap({
      "teamA" : teams[0],
      "teamB" : teams[1],
      "teamAScore" : random.nextInt(2),
      "teamBScore" : random.nextInt(2),
      "duration" : random.nextInt(10),
      "createdAt" : DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      "updatedAt" : DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
    });
  }
}