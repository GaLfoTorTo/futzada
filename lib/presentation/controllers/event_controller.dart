import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/data/models/game_config_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/user_service.dart';
import 'package:futzada/data/services/api_service.dart';
import 'package:futzada/data/services/news_service.dart';
import 'package:futzada/data/repositories/event_repository.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===EVENT BASE===
abstract class EventBase {
  //GETTER - REPOSITORIES
  EventRepository get eventRepository;
  //GETTER - SERVIÇOS
  ApiService get apiService;
  NewsService get newsService;
  //GETTER - USUARIO, EVENTOS, EVENTOS DO USUARIO
  UserModel get user;
  //GETTER - EVENTOS DO USUARIO
  List<EventModel> get events;
  //GETTER - EVENTO
  EventModel get event;
  //SETTER - EVENTO
  set event(EventModel event);
  //GETTER - PARTICIPANTS
  Map<String, List<UserModel>?> get participants;
  //DEFINIR TRAVEL MODEL ATUAL SENDO MANIPULADO
  RxString get travelMode;
}

//===CONTROLLER PRINCIPALS===
class EventController extends GetxController 
  with EventOverview, EventRegister, EventParticipants, EventRules implements EventBase {
  
  //GETTER - INSTANCIA DE CONTROLLER DE EVENTOS
  static EventController get instance => Get.find();

  //DEFINIR SERVIÇO DE EVENTO - OBRIGATÓRIO
  @override
  final EventRepository eventRepository = EventRepository();
  
  //DEFINIR SERVIÇO DE FORMULÁRIO - OBRIGATÓRIO
  @override
  final ApiService apiService = ApiService();

  //DEFINIR SERVIÇO DE FORMULÁRIO - OBRIGATÓRIO
  @override
  final NewsService newsService = NewsService();
  
  //DEFINIR USUARIO LOGADO - OBRIGATÓRIO
  @override
  final UserModel user = Get.find(tag: 'user');
  
  //DEFINIR EVENTOS DO USUARIO LOGADO - OBRIGATÓRIO
  @override
  final List<EventModel> events = Get.find(tag: 'events');
  
  //DEFINIR EVENTO ATUAL SENDO MANIPULADO - OBRIGATÓRIO
  @override
  late EventModel event;
  
  //DEFINIR DE PARTICIPANTES
  @override
  late Map<String, List<UserModel>?> participants;
  
  //DEFINIR DE PARTICIPANTES
  @override
  late RxString travelMode = 'walking'.obs;

  @override
  void onReady() async{
    super.onReady();
  }

  //FUNÇÃO DE SELEÇÃO DE EVENTO
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
  Future<List<EventModel>> getSuggestions() async{
    //REGATAR SERVIÇO DE VENTO
    return await EventController.instance.eventRepository.getEvents() ?? [];
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
    final eventController = this as EventController;
    return GameConfigModel(
      category: category.value,
      eventId: eventController.event.id!,
      duration: int.parse(durationController.text),
      playersPerTeam: int.parse(playersPerTeamController.text),
      config: {
        "hasTwoHalves" : bool.parse(hasTwoHalvesController.text),
        "hasExtraTime" : bool.parse(hasExtraTimeController.text),
        "hasPenalty" : bool.parse(hasPenaltyController.text),
        "hasGoalLimit" : bool.parse(hasGoalLimitController.text),
        "hasRefereer" : bool.parse(hasRefereerController.text),
        "extraTime" : bool.parse(hasExtraTimeController.text) ? int.parse(extraTimeController.text) : null,
        "goalLimit" : bool.parse(hasGoalLimitController.text) ? int.parse(goalLimitController.text) : null,
      },
    );
  }

  //FUNÇÃO DE MONTAGEM DE OBJETO DE ENVIO PARA O FORMULÁRIO
  EventModel setEventRegister(){
    return EventModel(
      title: titleController.text,
      bio: bioController.text,
      date: daysWeek,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      collaborators: bool.parse(allowCollaboratorsController.text),
      photo: photoController.text,
      visibility: VisibilityProfile.values.firstWhere((item ) => item.name == visibilityController.text),
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
  //ESTADO - DIAS DA SEMANA SELECIOANADS
  RxList<String> daysWeek = <String>[].obs;
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
      "user": UserService().generateUser(i),
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
    try {  
      //RESGATAR EVENTO SELECIONADO
      EventModel event = setEventRegister();
      print(event);
      /* //BUSCAR URL BASICA
      String url = AppApi.url + AppApi.createEvent;
      //RESGATAR USUARIO LOGADO
      UserModel user = Get.find(tag: 'user');
      //RESGATAR OPTIONS
      var options = await ApiService.setOption(user);
      //ENVIAR FORMULÁRIO
      var response = await ApiService.sendForm(event, options, url);
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
  Map<String, List<UserModel>?> setParticipants(List<UserModel>? participants){
    Map<String, List<UserModel>?> map = {
      'Organizador': [],
      'Colaboradores': [],
      'Participantes' : []
    };
    if(participants != null && participants.isNotEmpty){
      participants.forEach((item){
        if(item.participants!.first.role != null){
          //VERIFICAR SE PARTICIPANTE E O ORGANIZADOR
          if(item.participants!.first.role!.contains(Roles.Organizator.name)){
            map['Organizador']?.add(item); 
          //VERIFICAR SE PARTICIPANTE E COLABORADOR
          }else if(item.participants!.first.role!.contains(Roles.Colaborator.name)){
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

//===MIXIN - RULES===
mixin EventRules on GetxController{
  //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
  late TextEditingController ruleTitleController;
  late QuillController ruleDescriptionController;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS
  void initRuleTextControllers(Map<String, String?> values) {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    ruleTitleController = TextEditingController(text: values['title']);
    ruleDescriptionController = QuillController(
      document: Document()..insert(0, values['description'] ?? ''),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }
  
  void disposeRuleTextControllers() {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    ruleTitleController.dispose();
    ruleDescriptionController.dispose();
  }
}