import 'dart:math';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/data/models/economy_model.dart';

class EconomyService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE ECONOMIA DO TECNICO
  EconomyModel generateEconomy(int managerId, int eventId){
    //DEFINIR ECONOMIA
    return EconomyModel.fromMap({
      "id" : random.nextInt(100),
      "managerId" : managerId,
      "eventId" : eventId,
      "patrimony" : 100.0,
      "price" : 0.0,
      "valuation" : 0.0,
      "points" : 0.0,
      "totalPoints" : 0.0,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }
}