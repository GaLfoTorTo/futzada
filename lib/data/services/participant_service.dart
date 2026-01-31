import 'dart:math';
import 'package:get/get.dart';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/participant_model.dart';

class ParticipantService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE TECNICO

  ParticipantModel generateParticipant(int eventId, int userId) {
    //DEFINIR STATUS DE PERMISSÃO
    bool permissionState = random.nextBool();
    //DEFINIR PERMISSÕES DO EVENTO
    List<String>? permissions = permissionState == true ? [Permissions.Add.name, Permissions.Edit.name, Permissions.Remove.name] : null;

    //DEFINIR PLAYER
    return ParticipantModel.fromMap({
      "id" : random.nextInt(100),
      "userId" : userId,
      "eventId" : eventId,
      "role" : setRoles(userId),
      "permissions" : permissions,
      "status" : setStatus(random.nextInt(3)),
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //FUNÇÃO PARA GERAÇÃO DE PARTICIPANTES
  List<ParticipantModel> generateParticipants(){
    return List.generate(50, (i){
      return generateParticipant(i, i);
    });
  }
  
  //FUNÇÃO PARA GERAR JOGADORES PARA MERCADO (TEMPORARIAMENTE)
  RxList<ParticipantModel> getParticipants() {
    //JUNTAR MAPS
    final List<ParticipantModel> arr = [];
    //GERAR LISTA DE JOGADORES
    List.generate(random.nextInt(100), (i){
      //ADICIONAR JOGADOR A LISTA
      arr.add(
        generateParticipant(i, i)
      );
    });
    return arr.obs;
  }
  
  //FUNÇÃO PARA GERAR STATUS DE PARTICIPANTE DA PELADA
  static String setStatus(i){
    switch (i) {
      case 0:
        return PlayerStatus.Avaliable.name;
      case 1:
        return PlayerStatus.Out.name;
      case 2:
        return PlayerStatus.Doubt.name;
      case 3:
        return PlayerStatus.None.name;
      default:
        return PlayerStatus.None.name;
    }
  }
  
  //FUNÇÃO PARA TRADUZIR STATUS DE PARTICIPANTE DA PELADA
  static String translateStatus(status){
    switch (status) {
      case PlayerStatus.Avaliable:
        return "Ativo";
      case PlayerStatus.Out:
        return "Inativo";
      case PlayerStatus.Doubt:
        return "Dúvida";
      case PlayerStatus.None:
        return "Neutro";
      default:
        return "Neutro";
    }
  }

  //FUNÇÃO PARA DEFINIR PERFIS DE PARTICIPANTES DO EVENTO
  List<String> setRoles(i){
    switch (i) {
      case 1:
        return [Roles.Organizator.name, Roles.Colaborator.name, Roles.Player.name, Roles.Manager.name];
      default:
        return List.generate(faker.randomGenerator.integer(4, min: 1), (i) => Roles.values[i + 1].name);
    }
  }
}