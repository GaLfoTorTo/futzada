import 'dart:math';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/services/avaliation_service.dart';
import 'package:futzada/services/game_service.dart';
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

  //INSTANCIAR SERVIÇO DE PARTIDAS
  GameService gameService = GameService();
  //INSTANCIAR SERVIÇO DE PARTICIPANTES
  ParticipantService participantService = ParticipantService();
  //INSTANCIAR SERVIÇO DE AVALIAÇÃO
  AvaliationService avaliationService = AvaliationService();

  //FUNÇÃO PARA GERAR EVENTO
  EventModel generateEvent(i){
    //DEFINIR QUANTIDADE DE PARTICIPANTES
    int qtdParticipants = random.nextInt(50);
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
      "daysWeek" : "[Seg, Qua, Sex]",
      "date" : null,//DateFormat('yyyy-MM-dd').format(faker.date.dateTime(minYear: 2024, maxYear: 2026)),
      "startTime" : faker.date.justTime(),
      "endTime" : faker.date.justTime(),
      "category" : gameService.getCategory(),
      "allowCollaborators" : permissionState,
      "permissions" : permissions,
      "photo" : random.nextBool() == true ? faker.image.loremPicsum() : null,
      //GERAR ENDEREÇO DO EVENTO (PELADA)
      "address" : generateAddress(i).toMap(),
      //GERAR CONFIGURAÇÕES DE PARTIDA DO EVENTO (PELADA)
      "gameConfig" : gameService.generateGameConfig(i).toMap(),
      //GERAR AVALIAÇÕES DO EVENTO (PELADA)
      "avaliations" : List.generate(qtdAvaliations, (u) => avaliationService.generateAvaliation(u + 1).toMap()),
      //GERAR PARTICIPANTES DO EVENTO (PELADA)
      "participants" : List.generate(qtdParticipants, (u) => participantService.generateParticipant(u + 1).toMap()),
      "visibility" : random.nextBool() == true ? VisibilityPerfil.Public.name : VisibilityPerfil.Private.name,
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAÇÃO DE ENDEREÇO
  AddressModel generateAddress(int i){
    return AddressModel.fromMap({
      "id" : i,
      "street" : faker.address.streetAddress(),
      "number" : random.nextInt(10).toString(),
      "city" : faker.address.city(),
      "state" : faker.address.stateAbbreviation(),
      "complement" : faker.address.streetSuffix(),
      "country" : faker.address.country().toString(),
      "zipCode" : faker.address.zipCode(),
      "latitude" : faker.geo.latitude(),
      "longitude" : faker.geo.longitude(),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
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

  //FUNÇÃO PARA VERIFICAR SE EVENTO ESTA AO VIVO
  bool isEventLive(EventModel event){
    //VERIFICAR SE EVENTO TEM DATA FIXA
    if(event.date != null){
      //VERIFICAR SE O EVENTO ESTA ACONTECENDO AGORA
      return AppHelper.verifyInLive("${event.date} ${event.startTime}", "${event.date} ${event.endTime}");
      //return = AppHelper.verifyInLive("31/05/2025 11:00", "31/05/2025 13:00");
    }
    //RESGATAR DATAS DE ACONTECIMENTO DO EVENTO
    var eventDateTime = getNextEventDate(event);
    var eventDate = DateFormat("dd/MM/yyyy").format(eventDateTime);
    //VERIFICAR SE O EVENTO ESTA ACONTECENDO AGORA
    return AppHelper.verifyInLive("$eventDate ${event.startTime}", "$eventDate ${event.endTime}");
  }

  //FUNÇÃO PARA RESGATAR A DATA DO PROXIMO DIA DO EVENTO
  DateTime getNextEventDate(EventModel event) {
    //RESGATAR DATA FIXA DO EVENTO
    if (event.date != null) return DateFormat("dd/MM/yyyy").parse(event.date!);
    //LISTA DE DIAS DA SEMANA ABREVIADOS
    List<String> weekDays = ['Dom','Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    //RESGATAR DIAS DA SEMANA DO EVENTO
    final eventDaysWeek = event.daysWeek!
      .replaceAll(RegExp(r'[\[\]]'), '')
      .split(',')
      .map((d) => weekDays.indexOf(d.trim()))
      .toList();
    //RESGATAR DATA DE HOJE E INDEX DO DIA DA SEMANA
    DateTime today = DateTime.now();
    final todayIndex = today.weekday % 7;
    //VERIFICAR SE INDEX DO DIA DE HOJE (NA SEMANA) É MAIOR DO QUE INDEX DO ULTIMA DATA DO EVENTO (NA SEMANA)
    final nextDay = eventDaysWeek.firstWhere(
      (day) => day > todayIndex,
      orElse: () => eventDaysWeek.first + 7,
    );
    //ADICIONAR NOVA DATA DO EVENTO BASEADO NA DATA DE HOJE E NO INDEX DE PROXMO EVENTO ADIQUIRIDO;
    return DateTime(
      today.year,
      today.month,
      today.day + (nextDay - todayIndex),
    );
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }
}