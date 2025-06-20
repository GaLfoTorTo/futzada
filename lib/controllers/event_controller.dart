import 'package:get/get.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/services/form_service.dart';
import 'package:futzada/services/event_service.dart';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
  //CONTROLLERS DE CADA CAMPO
  late final TextEditingController titleController = TextEditingController();
  late final TextEditingController bioController = TextEditingController();
  late final TextEditingController addressController = TextEditingController();
  late final TextEditingController numberController = TextEditingController();
  late final TextEditingController cityController = TextEditingController();
  late final TextEditingController stateController = TextEditingController();
  late final TextEditingController complementController = TextEditingController();
  late final TextEditingController countryController = TextEditingController();
  late final TextEditingController zipCodeController = TextEditingController();
  late final TextEditingController daysWeekController = TextEditingController();
  late final TextEditingController dateController = MaskedTextController(mask: "00/00/0000");
  late final TextEditingController startTimeController = MaskedTextController(mask: "00:00");
  late final TextEditingController endTimeController = MaskedTextController(mask: "00:00");
  late final TextEditingController categoryController = TextEditingController();
  late final TextEditingController qtdPlayersController = TextEditingController();
  late final TextEditingController visibilityController = TextEditingController();
  late final TextEditingController allowCollaboratorsController = TextEditingController();
  late final TextEditingController photoController = TextEditingController();
  late final TextEditingController participantsController = TextEditingController();
  late final TextEditingController permissionsController = TextEditingController();
  //ESTADO - DIAS DA SEMANA
  final RxList<dynamic> daysOfWeek = [].obs;
  //ESTADO - PERMISSÕES
  final RxMap<String, dynamic> permissions = <String, dynamic>{
    'Adicionar': false,
    'Editar': false,
    'Remover': false,
  }.obs;
  //ESTADO - COLABORADORES
  bool activeColaboradors = false;
  //ESTADO - PESQUISA DE ENDEREÇOS
  RxBool isSearching = false.obs;
  //ESTADO - MENSAGEM DE ENDEREÇO
  RxString enderecoMessage = ''.obs;
  //ESTADO - ENDEREÇOS
  final RxList<dynamic> enderecos = [].obs;
  //ESTADO - CONFIGURAÇÕES DE CONVITE
  final RxList<Map<String, dynamic>> invite = <Map<String, dynamic>>[
    {
      'label': 'Participar como Jogador',
      'name': 'jogador',
      'icon': AppIcones.foot_field_solid,
      'checked': true,
    },
    {
      'label': 'Participar como Técnico',
      'name': 'tecnico',
      'icon': AppIcones.clipboard_solid,
      'checked': false,
    },
    {
      'label': 'Participar como Árbitro',
      'name': 'arbitro',
      'icon': AppIcones.apito,
      'checked': false,
    },
    {
      'label': 'Participar como Colaborador',
      'name': 'colaborador',
      'icon': AppIcones.user_cog_solid,
      'checked': false,
    },
  ].obs;
  //ESTADO - PARTICIPANTES CONVIDADOS
  final RxList<dynamic> participantes = [].obs;
  //ESTADO - AMIGOS
  final RxList<Map<String, dynamic>> amigos = [
    for(var i = 0; i <= 15; i++)
      {
        'id': i,
        'nome': 'Jeferson Vasconcelos',
        'userName': 'jeff_vasc',
        'posicao': null,
        'foto': null,
        'checked': false,
      },
  ].obs;
  
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