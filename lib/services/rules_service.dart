import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/models/rule_model.dart';

class RuleService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  RuleModel generateRule(ParticipantModel participant, int i) {
    //GERAR EQUIPE (TIME)
    return RuleModel.fromMap({
      "id": i,
      "title": faker.sport.name(),
      "description": faker.lorem.sentence().toString(),
      "author": participant.toMap(),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }
}