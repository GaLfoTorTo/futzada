import 'dart:math';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/rating_model.dart';

class RatingService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE RATING (PONTUAÇÕES)
  RatingModel generateRating(Roles role){
    //DEFINIR VARIAVESI DE CALCULO DE RATING DO JOGADORT
    double count = double.parse(setValues(0.0, 10.0).toStringAsFixed(2));
    int games = random.nextInt(50);
    double avarage = double.parse((count / games).toStringAsFixed(2));
    //DEFINIR PLAYER
    return RatingModel.fromMap({
      "modality" : role,
      "points" : double.parse(setValues(0.0, 10.0).toStringAsFixed(2)),
      "avarage" : avarage,
      "valuation" : double.parse(setValues(0.0, 10.0).toStringAsFixed(2)),
      "price" : double.parse(setValues(0.0, 10.0).toStringAsFixed(2)),
      "games" : games,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}