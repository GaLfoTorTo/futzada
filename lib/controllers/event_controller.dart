import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:futzada/services/form_service.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/api/api.dart';
import 'package:futzada/models/event_model.dart';

class EventController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETX
  static EventController get instace => Get.find();
  //INSTANCIA DE PELADA MODEL
  EventModel model = EventModel();
  // CONTROLLERS DE CADA CAMPO
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
  //CONTROLLER DE DIAS DA SEMANA
  final RxList<dynamic> daysOfWeek = [].obs;
  //CONTROLLER DE PERMISSÕES
  //LISTA DE INPUTS CHECKBOX
  final RxMap<String, dynamic> permissions = <String, dynamic>{
    'Adicionar': false,
    'Editar': false,
    'Remover': false,
  }.obs;
  //CONTROLLER DE COLABORADORES
  bool activeColaboradors = false;
  //CONTROLLER DE SLIDER
  double qtdPlayers = 11;
  double minPlayers = 8;
  double maxPlayers = 11;
  int divisions = 3;
  //CONTROLADOR DE PESQUISA DE ENDEREÇOS
  RxBool isSearching = false.obs;
  RxString enderecoMessage = ''.obs;
  //LISTA DE ENDEREÇOS
  final RxList<dynamic> enderecos = [].obs;
  // CONFIGURAÇÕES DE invite
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
  
  //LISTA DE PARTICIPANTES CONVIDADOS
  final RxList<dynamic> participantes = [].obs;
  //LISTA DE AMIGOS
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

  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }

  void onSaved(Map<String, dynamic> updates) {
    model = model.copyWithMap(updates: updates);
    print(model);
  }

  Future<Map<String, dynamic>> registerEvent() async {
    //BUSCAR URL BASICA
    var url = AppApi.url+AppApi.createEvent;
    //RESGATAR USUARIO
    var user = Get.find(tag: 'user');
    //RESGATAR OPTIONS
    var options = await FormService.setOption(user);
    //ENVIAR FORMULÁRIO
    var response = await FormService.sendForm(model, options, url);
    return response;
  }
}
