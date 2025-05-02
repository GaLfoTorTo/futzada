import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:futzada/services/form_service.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/event_model.dart';

class EventController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static EventController get instace => Get.find();
  //INSTANCIA DE PELADA MODEL
  EventModel model = EventModel();
  //lIST
  //*
  //*
  //*
  //LISTA DE EVENTOS
  final RxList<Map<String, dynamic>> events = [
    for(var i = 0; i <= 2; i++)
      {
        'uuid': i,
        'title': 'Jeferson Vasconcelos',
        'date' : 'Seg - Sex',
        'startTime' : '17:00',
        'endTime' : '18:30',
        'location' : 'Brasília/DF',
        'photo': AppImages.gramado,
      },
  ].obs;
  //LISTA DE EVENTOS SUGERIDOS
  final RxList<Map<String, dynamic>> sugestions = [
    for(var i = 0; i <= 1; i++)
      {
        'uuid': i,
        'title': 'Jeferson Vasconcelos',
        'date' : 'Seg - Sex',
        'startTime' : '17:00',
        'endTime' : '18:30',
        'location' : 'Brasília/DF',
        'photo': AppImages.userDefault,
      },
  ].obs;
  //REGISTER
  //*
  //*
  //*
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
  int qtdPlayers = 11;
  int minPlayers = 8;
  int maxPlayers = 11;
  int divisions = 3;
  //FUNÇÃO QUE DEFINE A FORMAÇÃO NA AMOSTRAGEM DO CAMPO APARTIR DA QUANTIDADE DE JOGADORES DEFINA
  List<int> setFormation(qtd){
    switch (qtd) {
      case 4:
        //SETORES PARA 4 JOGADORES
        return [0, 2, 1];
      case 5:
        //SETORES PARA 5 JOGADORES
        return [1, 2, 1];
      case 6:
        //SETORES PARA 6 JOGADORES
        return [1, 2, 2];
      case 7:
        //SETORES PARA 7 JOGADORES
        return [1, 3, 2];
      case 8:
        //SETORES PARA 8 JOGADORES
        return [2, 3, 2];
      case 9:
        //SETORES PARA 9 JOGADORES
        return [2, 3, 3];
      case 10:
        //SETORES PARA 10 JOGADORES
        return [3, 3, 3];
      case 11:
        //SETORES PARA 11 JOGADORES
        return [3, 4, 4];
      default:
        return [3, 4, 4];
    }
  }
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
