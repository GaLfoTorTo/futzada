import 'dart:math';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/repository/user_repository.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';

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
      "avaliation" : double.parse(setValues(0.0, 10.0).toStringAsFixed(2)),
      "comment" : faker.lorem.sentence().toString(),
      "createdAt" : DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      "updatedAt" : DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
    });
  }

  //FUNÇÃO PARA GERAR AVALIAÇÕES DO EVENTO
  List<AvaliationModel> getAvaliations() {
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