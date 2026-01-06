import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/models/user_model.dart';
import 'package:futzada/services/manager_service.dart';
import 'package:futzada/services/player_service.dart';

class UserRepository {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();
  
  //INSTANCIAR SERVIÇO DE JOGADORES
  PlayerService playerService = PlayerService();
  //INSTANCIAR SERVIÇO DE TENICOS
  ManagerService managerService = ManagerService();
  
  //FUNÇÃO DE GERAÇÃO DE USUARIOS
  UserModel generateUser(int i, bool hasRole){
    //DEFINIR USUARIO
    return UserModel.fromMap({
      "id" : i,
      "uuid" : "$i",
      "firstName": faker.person.firstName(),
      "lastName": faker.person.lastName(),
      "userName": "${faker.person.firstName()}_${faker.person.lastName()}",
      "photo": faker.image.loremPicsum(),
      //DEFINIR ALEATORIAMENTE SE PARTICIPANTE ATUARÁ COMO JOGADOR
      "player": hasRole
        ? playerService.generatePlayer(i).toMap()
        : null,
      //DEFINIR ALEATORIAMENTE SE PARTICIPANTE ATUARÁ COMO TÉCNICO
      "manager": hasRole
        ? managerService.generateManager(i).toMap()
        : null,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
"updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }
}