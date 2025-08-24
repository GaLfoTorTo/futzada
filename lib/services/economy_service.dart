import 'dart:math';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/models/economy_model.dart';
import 'package:intl/intl.dart';

class EconomyService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE ECONOMIA DO TECNICO
  EconomyModel generateEconomy(i){
    /* double price = double.parse(setValues(0.0, 120.0).toStringAsFixed(2));
    double patrimony = 120.0 - price;
    patrimony = double.parse(patrimony.toStringAsFixed(2)); */
    //DEFINIR ECONOMIA
    return EconomyModel.fromMap({
      "id" : i,
      "patrimony" : 100.0,
      "price" : 0.0,
      "valuation" : 0.0,
      "points" : 0.0,
      "totalPoints" : 0.0,
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}