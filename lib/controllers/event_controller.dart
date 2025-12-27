import 'package:futzada/models/participant_model.dart';
import 'package:futzada/services/user_service.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/services/form_service.dart';
import 'package:futzada/services/event_service.dart';
import 'package:futzada/controllers/game_controller.dart';

//===EVENT BASE===
abstract class EventBase {
  //GETTER - SERVIÇO DE EVENTO
  EventService get eventService;
  //GETTER - SERVIÇO DE FORMULÁRIO
  FormService get formService;
  //GETTER - USUARIO
  UserModel get user;
  //GETTER - EVENTOS DO USUARIO
  List<EventModel> get myEvents;
  //GETTER - EVENTO
  EventModel get event;
  //SETTER - EVENTO
  set event(EventModel event);
  //GETTER - PARTICIPANTS
  Map<String, List<ParticipantModel>?> get participants;
  //DEFINIR TRAVEL MODEL ATUAL SENDO MANIPULADO
  RxMap<String, dynamic> get travelMode;
}

//===CONTROLLER PRINCIPALS===
class EventController extends GetxController 
  with EventOverview, EventRegister, EventParticipants implements EventBase {
  
  //GETTER - INSTANCIA DE CONTROLLER DE EVENTOS
  static EventController get instance => Get.find();

  //DEFINIR SERVIÇO DE EVENTO - OBRIGATÓRIO
  @override
  final EventService eventService = EventService();
  
  //DEFINIR SERVIÇO DE FORMULÁRIO - OBRIGATÓRIO
  @override
  final FormService formService = FormService();
  
  //DEFINIR USUARIO LOGADO - OBRIGATÓRIO
  @override
  final UserModel user = Get.find(tag: 'user');
  
  //DEFINIR EVENTOS DO USUARIO LOGADO - OBRIGATÓRIO
  @override
  final List<EventModel> myEvents = Get.find(tag: 'events');
  
  //DEFINIR EVENTO ATUAL SENDO MANIPULADO - OBRIGATÓRIO
  @override
  late EventModel event;
  
  //DEFINIR DE PARTICIPANTES
  @override
  late Map<String, List<ParticipantModel>?> participants;
  
  //DEFINIR DE PARTICIPANTES
  @override
  late RxMap<String, dynamic> travelMode =  <String, dynamic>{
    'type': 'walking',
    'icon' : AppIcones.walk_solid,
    'label': 'A pé',
    'distance': '2 min'
  }.obs;

  //FUNÇÃO DE SELEÇÃO DE EVENTO
  void setSelectedEvent(EventModel event) {
    //RESGATAR E DEFINIR EVENTO NOS CONTROLLERS
    this.event = event;
    //ATUALIZAR EVENTO NO CONTROLLER DE PARTIDAS
    GameController.instance.event = event;
    //ATUALIZAR CONFIGURAÇÕES DE PARTIDA NO CONTROLLER DE PARTIDAS
    GameController.instance.currentGameConfig = event.gameConfig;
    //DEFINIR PARTICIPANTS
    this.participants = setParticipants(event.participants);
  }

  //FUNÇÃO DE DEFINIÇÃO DE TRAVEL MODEL
  void setTravelMode(Map<String, dynamic> newTravelMode){
    travelMode.value = newTravelMode;
    Get.back();
  }
}

//===MIXIN - VISÃO GERAL===
mixin EventOverview on GetxController{
  //FUNÇÃO PARA BUSCAR SUGESTÕES DE EVENTOS
  List<EventModel> getSuggestions() {
    //REGATAR SERVIÇO DE VENTO
    EventService eventService = EventController.instance.eventService;
    return eventService.getSuggestionEvents();
  }
  //FUNÇÃO PARA BUSCAR SUGESTÕES DE EVENTOS
  List<Map<String, dynamic>> getHighlights(EventModel event) {
    //REGATAR SERVIÇO DE VENTO
    EventService eventService = EventController.instance.eventService;
    return eventService.getHighlightsEvent();
  }
  //FUNÇÃO PARA BUSCAR AVALIAÇÕES DO EVNTO
  double getAvaliations(List<AvaliationModel>? avaliations) {
    if(avaliations == null || avaliations.isEmpty) return 0.0;
    return avaliations.map((a) => a.avaliation!).reduce((a, b) => a + b) / avaliations.length;
  }
}

//===MIXIN - REGISTRO EVENTO===
mixin EventRegister on GetxController{
  //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
  late TextEditingController titleController;
  late TextEditingController bioController;
  late TextEditingController photoController;
  late TextEditingController allowCollaboratorsController;
  late TextEditingController visibilityController;
  //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
  AddressModel addressEvent = AddressModel();
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  //CONTROLLERS DE CONFIGURAÇÕES DE PARTIDA DO EVENTO
  late TextEditingController categoryController;
  late TextEditingController durationController;
  late TextEditingController hasTwoHalvesController;
  late TextEditingController hasExtraTimeController;
  late TextEditingController hasPenaltyController;
  late TextEditingController hasGoalLimitController;
  late TextEditingController hasRefereerController;
  late TextEditingController playersPerTeamController;
  late TextEditingController extraTimeController;
  late TextEditingController goalLimitController;
  //CONTROLLERS DE PARTICIPANTES DO EVENTO
  late TextEditingController participantsController;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS
  void initTextControllers() {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    titleController = TextEditingController();
    bioController = TextEditingController();
    photoController = TextEditingController();
    allowCollaboratorsController = TextEditingController(text: 'false');
    visibilityController = TextEditingController();
    //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
    dateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    //CONTROLLADORES DE PARTIDAS DO EVENTO
    categoryController = TextEditingController();
    durationController = TextEditingController();
    hasTwoHalvesController = TextEditingController(text: 'false');
    hasExtraTimeController = TextEditingController(text: 'false');
    hasPenaltyController = TextEditingController(text: 'false');
    hasGoalLimitController = TextEditingController(text: 'false');
    hasRefereerController = TextEditingController(text: 'false');
    playersPerTeamController = TextEditingController();
    extraTimeController = TextEditingController();
    goalLimitController = TextEditingController();
    //CONTROLLERS DE PARTICIPANTES DO EVENTO
    participantsController = TextEditingController();
  }

  //FUNÇÃO PARA FINALIZAR CONTROLLERS
  void disposeTextControllers() {
    titleController.dispose();
    bioController.dispose();
    photoController.dispose();
    allowCollaboratorsController.dispose();
    visibilityController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    categoryController.dispose();
    durationController.dispose();
    hasTwoHalvesController.dispose();
    hasExtraTimeController.dispose();
    hasPenaltyController.dispose();
    hasGoalLimitController.dispose();
    hasRefereerController.dispose();
    playersPerTeamController.dispose();
    extraTimeController.dispose();
    goalLimitController.dispose();
    participantsController.dispose();
  }

  //FUNÇÃO DE MONTAGEM DE OBJETO DE CONFIGURAÇÕES DA PARTIDA
  GameConfigModel setGameConfigEvent(){
    return GameConfigModel(
      category: category.value,
      duration: int.parse(durationController.text),
      hasTwoHalves: bool.parse(hasTwoHalvesController.text),
      hasExtraTime: bool.parse(hasExtraTimeController.text),
      hasPenalty: bool.parse(hasPenaltyController.text),
      hasGoalLimit: bool.parse(hasGoalLimitController.text),
      hasRefereer: bool.parse(hasRefereerController.text),
      playersPerTeam: int.parse(playersPerTeamController.text),
      extraTime: bool.parse(hasExtraTimeController.text) ? int.parse(extraTimeController.text) : null,
      goalLimit: bool.parse(hasGoalLimitController.text) ? int.parse(goalLimitController.text) : null,
    );
  }

  //FUNÇÃO DE MONTAGEM DE OBJETO DE ENVIO PARA O FORMULÁRIO
  EventModel setEventRegister(){
    return EventModel(
      title: titleController.text,
      bio: bioController.text,
      daysWeek: daysOfWeek.toString(),
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      allowCollaborators: bool.parse(allowCollaboratorsController.text),
      permissions: bool.parse(allowCollaboratorsController.text) ? permissions.toString() : null,
      photo: photoController.text,
      visibility: VisibilityPerfil.values.firstWhere((item ) => item.name == visibilityController.text),
      address: addressEvent,
      gameConfig: setGameConfigEvent(),
    );
  }
  
  //ESTADOS DE PERMISSÃO
  RxMap<String, dynamic> permissions = {
    'Adicionar': false,
    'Editar': false,
    'Remover': false,
  }.obs;

  //LISTA DE DIAS DA SEMANA
  RxMap<String, bool> daysOfWeek = {
    'Dom': false,
    'Seg': false,
    'Ter': false,
    'Qua': false,
    'Qui': false,
    'Sex': false,
    'Sab': false,
  }.obs;

  //MAP DE CONVITE PADRÃO
  RxMap<String, bool> invite = {
    'Jogador': false,
    'Técnico': false,
    'Arbitro': false,
    'Colaborador': false,
  }.obs;

  //LISTA DE AMIGOS
  RxList<Map<String, dynamic>> friends = List.generate(30, (i){
    return {
      "invite": {
        'Jogador': false,
        'Técnico': false,
        'Arbitro': false,
        'Colaborador': false,
      }.obs,
      "checked": false.obs,
      "user": UserService().userRepository.generateUser(i, true),
    };
  }).obs;

  //ESTADO - CATEGORIA
  RxString category = "".obs;
  //ESTADO - LABEL DE DATA
  RxString labelDate = 'Dias da Semana'.obs;
  //ESTADO - MENSAGEM DE ENDEREÇO
  RxString addressText = 'Escolher endereço'.obs;

  //FUNÇÃO DE ENVIO DE FORMULARIO
  Future<Map<String, dynamic>> registerEvent() async {
    //RESGATAR INSTANCIA DO CONTROLLER
    EventController eventController = EventController.instance;
    try {  
      //RESGATAR EVENTO SELECIONADO
      EventModel event = setEventRegister();
      print(event);
      eventController.setSelectedEvent(event);
      /* //BUSCAR URL BASICA
      String url = AppApi.url + AppApi.createEvent;
      //RESGATAR USUARIO LOGADO
      UserModel user = Get.find(tag: 'user');
      //RESGATAR OPTIONS
      var options = await FormService.setOption(user);
      //ENVIAR FORMULÁRIO
      var response = await FormService.sendForm(event, options, url);
      return response; */
      return {'status': 200};
    } catch (e) {
      print(e);
      //RETORNAR STATUS DE ERRO
      return {'status': 400};
    }
  }
}

//===MIXIN - RANKING===
mixin EventRanking on GetxController{
}

//===MIXIN - PARTICIPANTS===
mixin EventParticipants on GetxController{
  //FUNÇÃO DE CATEGORIZAÇÃO DE PARTICIPANTS
  Map<String, List<ParticipantModel>?> setParticipants(List<ParticipantModel>? participants){
    Map<String, List<ParticipantModel>?> map = {
      'Organizador': [],
      'Colaboradores': [],
      'Participantes' : []
    };
    if(participants != null && participants.isNotEmpty){
      participants.forEach((item){
        if(item.role != null){
          //VERIFICAR SE PARTICIPANTE E O ORGANIZADOR
          if(item.role!.contains(Roles.Organizator.name)){
            map['Organizador']?.add(item); 
          //VERIFICAR SE PARTICIPANTE E COLABORADOR
          }else if(item.role!.contains(Roles.Colaborator.name)){
            map['Colaboradores']?.add(item);
          //VERIFICAR SE PARTICIPANTE E JOGADOR
          }else {
            map['Participantes']?.add(item);
          }
        }
      });
    }
    return map;
  }

  //CONTROLADOR DE INPUT DE PESQUISA
  final TextEditingController pesquisaController = TextEditingController();
}