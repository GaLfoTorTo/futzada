import 'dart:math';
import 'package:faker/faker.dart';
import 'package:futzada/core/api/api.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/services/api_service.dart';
import 'package:futzada/data/services/event_service.dart';
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
      //DEFINIR ALEATORIAMENTE SE PARTICIPANTE ATUARÁ COMO TÉCNICO
      "privacy": Privacy.values[random.nextInt(2)].name,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
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