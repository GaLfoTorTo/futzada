import 'dart:math';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/models/economy_model.dart';

class EconomyService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE ECONOMIA DO TECNICO
  EconomyModel generateEconomy(i){
    double price = double.parse(setValues(0.0, 120.0).toStringAsFixed(2));
    double patrimony = 120.0 - price;
    patrimony = double.parse(patrimony.toStringAsFixed(2));
    //DEFINIR ECONOMIA
    return EconomyModel.fromMap({
      "id" : i,
      "patrimony" : patrimony,
      "price" : price,
      "valuation" : double.parse(setValues(0.0, 5.0).toStringAsFixed(2)),
      "points" : double.parse(setValues(0.0, 100.0).toStringAsFixed(2)),
      "totalPoints" : double.parse(setValues(0.0, 500.0).toStringAsFixed(2)),
    });
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}