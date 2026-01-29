import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/data/models/avaliation_model.dart';
import 'package:futzada/data/services/user_service.dart';

class AvaliationService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INSTANCIAR SERVIÇO DE USUARIO
  UserService userService = UserService();

  //FUNÇÃO DE GERAÇÃO DE TECNICO
  AvaliationModel generateAvaliation(int i, int userId, int eventId) {
    //DEFINIR PLAYER
    return AvaliationModel.fromMap({
      "id" : i,
      "userId" : userId,
      "eventId" : eventId,
      "avaliation" : double.parse(setValues(0.0, 5.0).toStringAsFixed(2)),
      "comment" : faker.lorem.sentence().toString(),
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //FUNÇÃO PARA GERAR AVALIAÇÕES DO EVENTO
  List<AvaliationModel> getEventAvaliation() {
    //JUNTAR MAPS
    final List<AvaliationModel> arr = [];
    //GERAR LISTA DE JOGADORES
    List.generate(random.nextInt(100), (i){
      //ADICIONAR JOGADOR A LISTA
      arr.add(generateAvaliation(i, i ,i));
    });
    return arr;
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}