import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/repository/user_repository.dart';

class AvaliationService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //INSTANCIAR SERVIÇO DE USUARIO
  UserRepository userRepository = UserRepository();

  //FUNÇÃO DE GERAÇÃO DE TECNICO
  AvaliationModel generateAvaliation(i){
    //DEFINIR PLAYER
    return AvaliationModel.fromMap({
      "id" : i,
      "user" : userRepository.generateUser(i, false).toMap(),
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
      arr.add(
        generateAvaliation(i)
      );
    });
    return arr;
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}