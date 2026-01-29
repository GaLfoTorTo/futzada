import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/data/services/economy_service.dart';
import 'package:futzada/data/services/escalation_service.dart';
import 'package:futzada/data/models/manager_model.dart';

class ManagerService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  EscalationService escalationService = EscalationService();
  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  EconomyService economyService = EconomyService();

  //FUNÇÃO DE GERAÇÃO DE TECNICO
  ManagerModel generateManager(int userId){
    int manageId = random.nextInt(100);
    //DEFINIR PLAYER
    return ManagerModel.fromMap({
      "id" : manageId,
      "userId" : userId,
      "team" : faker.company.name(),
      "alias" : faker.company.name().substring(1,4),
      "primary" : "green_300",
      "secondary" : "dark_500",
      "emblem" : null,
      "uniform" : null,
      "escalations" : [escalationService.generateEscalation('Futebol').toMap()],
      "economies" : List.generate(random.nextInt(5), (i) => economyService.generateEconomy(manageId, userId).toMap()),
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}