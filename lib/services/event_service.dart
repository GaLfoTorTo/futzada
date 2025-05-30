import 'dart:math';
import 'package:futzada/services/avaliation_service.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/services/participant_service.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/user_model.dart';

class EventService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INSTANCIAR SERVIÇO DE PARTICIPANTES
  ParticipantService participantService = ParticipantService();
  //INSTANCIAR SERVIÇO DE AVALIAÇÃO
  AvaliationService avaliationService = AvaliationService();

  //FUNÇÃO PARA GERAR EVENTO
  EventModel generateEvent(i){
    //DEFINIR QUANTIDADE DE PARTICIPANTES
    int qtdParticipants = random.nextInt(25);
    //DEFINIR QUANTIDADE DE AVALIAÇÕES
    int qtdAvaliations = random.nextInt(25);
    //DEFINIR STATUS DE PERMISSÃO
    bool permissionState = random.nextBool();
    //DEFINIR PERMISSÕES DO EVENTO
    String? permissions = permissionState == true ? [Permissions.Add.name, Permissions.Edit.name, Permissions.Remove.name].toString() : null;
    //GERAR EVENTO (PELADA)
    return EventModel.fromMap({
      "id" : i,
      "uuid" : "$i",
      "title" : faker.company.name(),
      "bio" : faker.lorem.sentence().toString(),
      "address" : faker.address.streetAddress(),
      "number" : random.nextInt(10).toString(),
      "city" : faker.address.city(),
      "state" : faker.address.stateAbbreviation(),
      "complement" : faker.address.streetSuffix(),
      "country" : faker.address.country().toString(),
      "zipCode" : faker.address.zipCode(),
      "daysWeek" : "[Seg, Qua, Sex]",
      "date" : DateFormat('dd/MM/yyyy').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      "startTime" : faker.date.justTime(),
      "endTime" : faker.date.justTime(),
      "category" : getCategory(),
      "qtdPlayers" : qtdParticipants,
      "visibility" : random.nextBool() == true ? VisibilityPerfil.Public.name : VisibilityPerfil.Private.name,
      "allowCollaborators" : permissionState,
      "permissions" : permissions,
      "photo" : random.nextBool() == true ? faker.image.loremPicsum() : null,
      //GERAR AVALIAÇÕES DO EVENTO (PELADA)
      "avaliations" : List.generate(qtdAvaliations, (u){
        return avaliationService.generateAvaliation(u + 1).toMap();
      }),
      //GERAR PARTICIPANTES DO EVENTO (PELADA)
      "participants" : List.generate(qtdParticipants, (u){
        return participantService.generateParticipant(u + 1).toMap();
      }),
    });
  }
  
  //FUNÇÃO PARA BUSCAR EVENTOS
  List<EventModel> getEvents(){
    //DEFINIR ARRAY DE EVENTOS
    List<EventModel> events = [];
    //LOOP PARA TITULARES
    for (var i = 1; i <= 2; i++) {
      //ADICIONAR JOGADOR A LISTA
      events.add(
        generateEvent(i)
      );
    }
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return events;
  }
  
  //FUNÇÃO PARA BUSCAR EVENTOS POR ID
  EventModel getEventById(int id){
    //BUSCAR EVENTO PELO ID
    return getEvents().firstWhere((event) => event.id == id, orElse: () => EventModel());
  }

  //FUNÇÃO PARA BUSCAR DESTAQUES DO EVENTOS
  List<Map<String, dynamic>> getHighlightsEvent(){
    List<Map<String, dynamic>> arr = [];
    //LOOP PARA TITULARES
    List.generate(random.nextInt(5), (item){
      //DEFINIR QUANTIDADE DE PARTICIPANTES
      int qtdParticipants = random.nextInt(3);
      qtdParticipants = qtdParticipants > 0 ? qtdParticipants : 1;
      //ADICIONAR JOGADOR A LISTA
      arr.add({
        'title' : faker.company.name(),
        'description' : faker.lorem.sentence().toString(),
        "participants" : List.generate(qtdParticipants, (p){
          return UserModel.fromMap({
            'uuid' : "$p",
            'firstName': faker.person.firstName(),
            'lastName': faker.person.lastName(),
            'userName': "${faker.person.firstName()}_${faker.person.lastName()}",
            'photo': faker.image.loremPicsum()
          });
        }),
        "params" : {
          'label' :  faker.company.name(),
          "value" : random.nextBool() 
            ? double.parse(setValues(0.0, 10.0).toStringAsFixed(2))
            : null
        }
      });
    });
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return arr;
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }

  //FUNÇÃO PARA RESGATAR CATEGORIA DO EVENTO
  String getCategory(){
    int num = random.nextInt(3);
    switch (num) {
      case 1:
        return "Futebol";
      case 2:
        return "Fut7";
      case 3:
        return "Futsal";
      default:
        return "Fut7";
    }
  }
}