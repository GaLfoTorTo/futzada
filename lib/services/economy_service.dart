import 'dart:math';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/models/economy_model.dart';

class EconomyService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE ECONOMIA DO TECNICO
  EconomyModel generateEconomy(i){
    //DEFINIR ECONOMIA
    return EconomyModel.fromMap({
      "id" : i,
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