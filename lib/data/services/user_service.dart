import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/core/api/api.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/achivment_model.dart';
import 'package:futzada/data/models/level_model.dart';
import 'package:futzada/data/models/user_config_model.dart';
import 'package:futzada/data/models/user_level_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/services/api_service.dart';
import 'package:futzada/data/services/manager_service.dart';
import 'package:futzada/data/services/participant_service.dart';
import 'package:futzada/data/services/player_service.dart';


class UserService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //INSTANCIAR SERVIÇOS - PARTICIPANT, JOGADOR, TECNICO, EVENTO
  ApiService apiService = ApiService();
  ParticipantService participantService = ParticipantService();
  ManagerService managerService = ManagerService();
  PlayerService playerService = PlayerService();
  
  //FUNÇÃO DE GERAÇÃO DE USUARIOS
  UserModel generateUser(int userId, {int? eventId}){
    //DEFINIR USUARIO
    return UserModel.fromMap({
      "id" : userId,
      "uuid" : faker.jwt.secret,
      "firstName": faker.person.firstName(),
      "lastName": faker.person.lastName(),
      "userName": "${faker.person.firstName()}_${faker.person.lastName()}",
      "photo": faker.image.loremPicsum(),
      "phone" : faker.phoneNumber.toString(),
      //DEFINIR ALEATORIAMENTE SE PARTICIPANTE ATUARÁ COMO JOGADOR
      "player": random.nextBool()
        ? playerService.generatePlayer(userId).toMap()
        : null,
      //DEFINIR ALEATORIAMENTE SE PARTICIPANTE ATUARÁ COMO TÉCNICO
      "manager": random.nextBool()
        ? managerService.generateManager(userId).toMap()
        : null,
      "participants": eventId != null
        ? [participantService.generateParticipant(eventId, userId).toMap()]
        : null,
      "userLevel": generateUserLevel(userId, faker.randomGenerator.integer(10, min: 1)).toMap(),
      "achievements": generateUserAchivments(userId).map((a) => a.toMap()).toList(),
      "config": generateUserConfig(userId).toMap(),
      //DEFINIR ALEATORIAMENTE SE PARTICIPANTE ATUARÁ COMO TÉCNICO
      "privacy": Privacy.values[faker.randomGenerator.integer(2, min: 0)].name,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //FUNÇÃO DE GERAÇÃO DE CONFIGURAÇÕES DO USUÁRIO
  UserConfigModel generateUserConfig(int userId){
    final modalities = List.generate(faker.randomGenerator.integer(3, min: 1), (m) => Modality.values[m].name);
    final len = modalities.length - 1;
    final index = faker.randomGenerator.integer(len, min: 0);
    
    return UserConfigModel.fromMap({
      "id": userId,
      "userId": userId,
      "mainModality": modalities[index],
      "modalities": modalities,
      "createdAt": DateTime.now(),
      "updatedAt": DateTime.now(),
    });
  }

  //FUNÇÃO DE GERAÇÃO DE NIVEIS
  LevelModel generateLevel(int levelId){
    return LevelModel.fromMap({
      "id": levelId,
      "number": levelId,
      "title": "Level $levelId",
      "points_min": (levelId - 1) * 100,
      "points_max": levelId * 100,
      "image": faker.image.loremPicsum(),
      "color": 'green_300',
    });
  }

  //FUNÇÃO DE GERAÇÃO DE NIVEL DO USUARIO
  UserLevelModel generateUserLevel(int userId, int levelId){
    return UserLevelModel.fromMap({
      "id": userId,
      "userId": userId,
      "levelId": levelId,
      "points": faker.randomGenerator.integer(100, min: 0),
      "level": generateLevel(levelId).toMap(),
    });
  }

  //FUNÇÃO DE GERAÇÃO DE CONQUISTAS
  AchivmentModel generateAchivment(int achivmentId){
    return AchivmentModel.fromMap({
      "id": achivmentId,
      "title": faker.lorem.words(2).join(' '),
      "description": faker.lorem.sentence(),
      "image": faker.image.loremPicsum(),
      "rarity": faker.randomGenerator.element(['Common', 'Rare', 'Epic', 'Legendary']),
      "points": faker.randomGenerator.integer(100, min: 10),
    });
  }

  //FUNÇÃO DE GERAÇÃO DE LISTA DE CONQUISTAS DO USUARIO
  List<AchivmentModel> generateUserAchivments(int userId){
    final numAchivments = faker.randomGenerator.integer(5, min: 0);
    return List.generate(numAchivments, (i) => generateAchivment(i + 1));
  }

  //FUNÇÃO PARA BUSCAR SUGESTÃO DE AMIGOS
  Future<List<UserModel>> fecthSuggestionFriends() async {
    //BUSCAR EVENTOS DO USUARIO
    return List.generate(10, (i){
      return generateUser(i);
    });
  }

  //FUNÇÃO DE BUSCA DE DADOS DO USUARIO
  Future<UserModel> fetchUser(int id) async{
    Future.delayed(Duration(milliseconds: 500));
    //BUSCAR USUARIO
    /* final response = await apiService.get('AppApi.getUrl("${AppApi.getUser}id");
    response['data'].map((json) => UserModel.fromJson(json)); */
    return generateUser(id);
  }
}