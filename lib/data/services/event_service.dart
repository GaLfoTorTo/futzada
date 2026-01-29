import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/core/api/api.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/user_service.dart';
import 'package:futzada/data/services/news_service.dart';
import 'package:futzada/data/services/rules_service.dart';
import 'package:futzada/data/services/avaliation_service.dart';
import 'package:futzada/data/services/game_service.dart';
import 'package:futzada/data/services/participant_service.dart';
import 'package:futzada/data/services/address_service.dart';

class EventService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INSTANCIAR SERVIÇOS - USUARIOS, PARTIDAS, PARTICIPANTS, AVALIAÇÕES, REGRAS, NOTICIAS
  AddressService addressService = AddressService();
  GameService gameService = GameService();
  ParticipantService participantService = ParticipantService();
  AvaliationService avaliationService = AvaliationService();
  RuleService ruleService = RuleService();
  NewsService newsService = NewsService();

  //FUNÇÃO PARA GERAR EVENTO
  EventModel generateEvent(int i){
    //CONTADORES DE ITENS FAKE
    int qtdAvaliations = faker.randomGenerator.integer(25);
    int qtdNews = faker.randomGenerator.integer(25);
    //DEFINIR STATUS DE PERMISSÃO
    bool permissionState = random.nextBool();
    List<String> daysWeek = ['Dom','Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    //GERAR EVENTO (PELADA)
    return EventModel.fromMap({
      "id" : i,
      "uuid" : faker.jwt.secret,
      "title" : faker.company.name(),
      "bio" : faker.lorem.sentence().toString(),
      "date" : List.generate(random.nextInt(6), (d) => daysWeek[d]),
      "startTime" : "${random.nextInt(23)}:${random.nextInt(59)}",
      "endTime" : "${random.nextInt(23)}:${random.nextInt(59)}",
      "modality" : Modality.values[random.nextInt(2)].name,
      "collaborators" : permissionState,
      "photo" : random.nextBool() == true ? faker.image.loremPicsum() : null,
      "visibility" : random.nextBool() == true ? VisibilityProfile.Public.name : VisibilityProfile.Private.name,
      //GERAR ENDEREÇO DO EVENTO (PELADA)
      "address" : addressService.generateAddress(i).toMap(),
      //GERAR CONFIGURAÇÕES DE PARTIDA DO EVENTO (PELADA)
      "gameConfig" : gameService.generateGameConfig(i).toMap(),
      //GERAR AVALIAÇÕES DO EVENTO (PELADA)
      "avaliations" : List.generate(qtdAvaliations, (u) => avaliationService.generateAvaliation(u + 1, i, i).toMap()),
      //GERAR NOTICIAS DO EVENTO (PELADA)
      "news" : List.generate(qtdNews, (u) => newsService.generateNews().toMap()),
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2026),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2026),
    });
  }

  //FUNÇÃO DE BUSCA EVENTO ESPECIFICO
  Future<EventModel> fetchEventById(int id) async{
    Future.delayed(Duration(milliseconds: 500));
    //BUSCAR USUARIO
    /* final response = await apiService.get('${AppApi.url}${AppApi.getEvent}/$id');
    response['data'].map((json) => UserModel.fromJson(json)); */
    return generateEvent(id);
  }
  
  //FUNÇÃO DE BUSCA DE TODOS OS EVENTOS
  Future<List<EventModel>> fetchEvents() async{
    UserService userService = UserService();
    Future.delayed(Duration(milliseconds: 500));
    //BUSCAR USUARIO
    /* final response = await apiService.get('${AppApi.url}${AppApi.getEvents}');
    response['data'].map((json) => UserModel.fromJson(json)); */
    //DEFINIR ARRAY DE EVENTOS
    List<EventModel> events = [];
    int count = faker.randomGenerator.integer(20, min: 1);
    //LOOP PARA EVENTOS DO USUARIO
    for (var i = 0; i <= count; i++) {
      //ADICIONAR JOGADOR A LISTA
      events.add(generateEvent(i));
      events[i].participants = List.generate(faker.randomGenerator.integer(50, min: 30), (p) => userService.generateUser(p, eventId: i));
    }
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return events;
  }

  //FUNÇÃO DE BUSCA DE DADOS DO USUARIO
  Future<List<EventModel>> fetchUserEvents(int? userId) async{
    UserService userService = UserService();
    Future.delayed(Duration(milliseconds: 500));
    //DEFINIR ARRAY DE EVENTOS
    List<EventModel> events = [];
    //BUSCAR USUARIO
    /* 
    final response = await apiService.get('AppApi.getUrl("${AppApi.getEvents}?userId=$userId");
    events = response['data'].map((json) => UserModel.fromJson(json)).toList();
     */
    if(random.nextBool()){
      int count = faker.randomGenerator.integer(5, min: 1);
      //LOOP PARA EVENTOS DO USUARIO
      for (var i = 0; i <= count; i++) {
        int e = i + 1;
        //ADICIONAR JOGADOR A LISTA
        events.add(generateEvent(e));
        events[i].participants = List.generate(faker.randomGenerator.integer(50, min: 30), (p) => userService.generateUser(p, eventId: i));
      }
    }
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return events;
  }
}