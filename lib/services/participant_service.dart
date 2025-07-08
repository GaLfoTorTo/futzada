import 'dart:math';
import 'package:get/get.dart';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/repository/user_repository.dart';
import 'package:intl/intl.dart';

class ParticipantService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();
  
  //INSTANCIAR SERVIÇO DE EVENTOS
  UserRepository userRepository = UserRepository();

  //FUNÇÃO DE GERAÇÃO DE TECNICO
  ParticipantModel generateParticipant(i, {bool hasRole = true}) {
    //DEFINIR STATUS DE PERMISSÃO
    bool roleState = random.nextBool();
    //DEFINIR PERMISSÕES DO EVENTO
    List<String>? roles = roleState == true ? setRoles(i) : null;
    //DEFINIR STATUS DE PERMISSÃO
    bool permissionState = random.nextBool();
    //DEFINIR PERMISSÕES DO EVENTO
    List<String>? permissions = permissionState == true ? [Permissions.Add.name, Permissions.Edit.name, Permissions.Remove.name] : null;

    //DEFINIR PLAYER
    return ParticipantModel.fromMap({
      "id" : i,
      "role" : roles,
      "permissions" : permissions,
      "status" : setStatus(random.nextInt(3)),
      "user" : userRepository.generateUser(i, hasRole).toMap(), //GERAR USUARIO VINCULADO AO EVENTO (PELADA)
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
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
        generateParticipant(i)
      );
    });
    return arr.obs;
  }

  //FUNÇÃO DE BUSCA DE JOGADOR NO ARRAY
  ParticipantModel? findPlayer(List<ParticipantModel> playersMarket, dynamic id) {
    return playersMarket.firstWhereOrNull((player) => player.id == id);
  }
  
  //FUNÇÃO PARA GERAR STATUS DE PARTICIPANTE DA PELADA
  static PlayerStatus setStatus(i){
    switch (i) {
      case 0:
        return PlayerStatus.Avaliable;
      case 1:
        return PlayerStatus.Out;
      case 2:
        return PlayerStatus.Doubt;
      case 3:
        return PlayerStatus.None;
      default:
        return PlayerStatus.None;
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
  List<String>? setRoles(i){
    switch (i) {
      case 1:
        return [Roles.Organizator.name, Roles.Colaborator.name, Roles.Player.name, Roles.Manager.name];
      case 2:
        return [Roles.Colaborator.name, Roles.Refereer.name, Roles.Player.name, Roles.Manager.name];
      case 3:
      case 4:
      case 7:
        return [Roles.Colaborator.name, Roles.Refereer.name, Roles.Player.name, Roles.Manager.name];
      default:
        return [Roles.Player.name, Roles.Manager.name];
    }
  }
}