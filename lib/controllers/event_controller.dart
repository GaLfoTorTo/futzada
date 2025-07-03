import 'package:futzada/models/address_model.dart';
import 'package:get/get.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter/material.dart';
import 'package:futzada/services/form_service.dart';
import 'package:futzada/services/event_service.dart';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/controllers/game_controller.dart';

//===EVENT BASE===
abstract class EventBase {
  //GETTER - SERVIÇO DE EVENTO
  EventService get eventService;
  //GETTER - USUARIO
  UserModel get user;
  //GETTER - EVENTOS DO USUARIO
  List<EventModel> get myEvents;
  //GETTER - EVENTO
  EventModel get event;
  //SETTER - EVENTO
  set event(EventModel event);
}

//===CONTROLLER PRINCIPALS===
class EventController extends GetxController 
  with EventOverview, EventRegister implements EventBase {
  
  //GETTER - INSTANCIA DE CONTROLLER DE EVENTOS
  static EventController get instance => Get.find();

  //DEFINIR SERVIÇO DE EVENTO - OBRIGATÓRIO
  @override
  final EventService eventService = EventService();
  
  //DEFINIR USUARIO LOGADO - OBRIGATÓRIO
  @override
  final UserModel user = Get.find(tag: 'user');
  
  //DEFINIR EVENTOS DO USUARIO LOGADO - OBRIGATÓRIO
  @override
  final List<EventModel> myEvents = Get.find(tag: 'events');
  
  //DEFINIR EVENTO ATUAL SENDO MANIPULADO - OBRIGATÓRIO
  @override
  late EventModel event;

  void setSelectedEvent(EventModel event) {
    //RESGATAR E DEFINIR EVENTO NOS CONTROLLERS
    this.event = event;
    //ATUALIZAR EVENTO NO CONTROLLER DE PARTIDAS
    GameController.instance.event = event;
    //ATUALIZAR CONFIGURAÇÕES DE PARTIDA NO CONTROLLER DE PARTIDAS
    GameController.instance.currentGameConfig = event.gameConfig;
  }
}

//===MIXIN - VISÃO GERAL===
mixin EventOverview on GetxController{
  //FUNÇÃO PARA BUSCAR SUGESTÕES DE EVENTOS
  List<EventModel> getSuggestions() {
    //REGATAR SERVIÇO DE VENTO
    EventService eventService = EventController.instance.eventService;
    return eventService.getEvents();
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
  late TextEditingController permissionsController;
  //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
  AddressModel addressEvent = AddressModel();
  late TextEditingController daysWeekController;
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  //CONTROLLADORES DE PARTIDAS DO EVENTO
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
    permissionsController = TextEditingController();
    //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
    daysWeekController = TextEditingController();
    dateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    //CONTROLLADORES DE PARTIDAS DO EVENTO
    categoryController = TextEditingController();
    durationController = TextEditingController();
    hasTwoHalvesController = TextEditingController();
    hasExtraTimeController = TextEditingController();
    hasPenaltyController = TextEditingController();
    hasGoalLimitController = TextEditingController();
    hasRefereerController = TextEditingController();
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
    permissionsController.dispose();
    daysWeekController.dispose();
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
  //ESTADOS DE PERMISSÃO
  final RxMap<String, dynamic> permissions = {
    'Adicionar': false,
    'Editar': false,
    'Remover': false,
  }.obs;

  //LISTA DE DIAS DA SEMANA
  final Map<String, dynamic> daysOfWeek = {
    'Dom': false,
    'Seg': false,
    'Ter': false,
    'Qua': false,
    'Qui': false,
    'Sex': false,
    'Sab': false,
  }.obs;

  //DEFINIR CATEGORIAS
  final Map<String, dynamic> categories = {
    "Futebol": false,
    "Fut7": false,
    "Futsal": false,
  }.obs;
  //ESTADO - MENSAGEM DE ENDEREÇO
  RxString addressText = 'Escolher endereço'.obs;
  //ESTADO - ENDEREÇOS
  final RxList<dynamic> enderecos = [].obs;
  
  //FUNÇÃO DE VALIDAÇÃO DE CAMPOS
  String? validateEmpty(String? value, String label) => (value?.isEmpty ?? true) ? "$label deve ser preenchido(a)!" : null;
  //FUNÇÃO DE ENVIO DE FORMULARIO
  Future<Map<String, dynamic>> registerEvent() async {
    //RESGATAR EVENTO SELECIONADO
    EventModel event = EventModel();
    //BUSCAR URL BASICA
    var url = AppApi.url+AppApi.createEvent;
    //RESGATAR USUARIO
    var user = Get.find(tag: 'user');
    //RESGATAR OPTIONS
    var options = await FormService.setOption(user);
    //ENVIAR FORMULÁRIO
    var response = await FormService.sendForm(event, options, url);
    return response;
  }
}