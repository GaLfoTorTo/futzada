import 'dart:math';
import 'package:faker/faker.dart';
import 'package:esportly/data/services/economy_service.dart';
import 'package:esportly/data/services/escalation_service.dart';
import 'package:esportly/data/models/manager_model.dart';

class ManagerService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  EscalationService escalationService = EscalationService();
  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  EconomyService economyService = EconomyService();

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}