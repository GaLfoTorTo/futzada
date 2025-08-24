import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/services/economy_service.dart';
import 'package:futzada/services/escalation_service.dart';
import 'package:futzada/models/manager_model.dart';

class ManagerService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  EscalationService escalationService = EscalationService();
  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  EconomyService economyService = EconomyService();

  //FUNÇÃO DE GERAÇÃO DE TECNICO
  ManagerModel generateManager(i){
    //DEFINIR PLAYER
    return ManagerModel.fromMap({
      "team" : faker.company.name(),
      "alias" : faker.animal.name(),
      "primary" : faker.color.color(),
      "secondary" : faker.color.color(),
      "emblem" : faker.company.name(),
      "uniform" : faker.company.name(),
      "economy" : economyService.generateEconomy(i).toMap(),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAR JOGADORES PARA MERCADO (TEMPORARIAMENTE)
  RxList<ManagerModel> getManagers() {
    //JUNTAR MAPS
    final List<ManagerModel> arr = [];
    //GERAR LISTA DE JOGADORES
    List.generate(random.nextInt(100), (i){
      //ADICIONAR JOGADOR A LISTA
      arr.add(
        generateManager(i)
      );
    });
    return arr.obs;
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}