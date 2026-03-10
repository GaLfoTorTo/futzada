//===MIXIN - REGISTRO EVENTO===
import 'package:flutter/widgets.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/game_config_model.dart';
import 'package:futzada/data/services/user_service.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:get/get.dart';

mixin EventRegisterMixin on GetxController{
  //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
  late TextEditingController titleController;
  late TextEditingController bioController;
  late TextEditingController photoController;
  late TextEditingController allowCollaboratorsController;
  late TextEditingController privacyController;
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
    privacyController = TextEditingController();
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
    privacyController.dispose();
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
      privacy: Privacy.values.firstWhere((item ) => item.name == privacyController.text),
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
