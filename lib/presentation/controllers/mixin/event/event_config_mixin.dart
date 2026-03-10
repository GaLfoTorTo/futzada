import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/game_config_model.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';


//===MIXIN - CONFIGURAÇÕES DO EVENTO===
mixin EventConfigMixin on GetxController{
  //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
  late TextEditingController titleController;
  late TextEditingController bioController;
  late TextEditingController photoController;
  late TextEditingController privacyController;
  late TextEditingController modalityController;
  //CONTROLLERS DE NOTIFICAÇÕES DO EVENTO
  late TextEditingController notificationController;
  //CONTROLLERS DE COLABORADORES DO EVENTO
  late TextEditingController allowCollaboratorsController;
  //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
  AddressModel addressEvent = AddressModel();
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  //CONTROLLERS DE CONFIGURAÇÕES PADRÃO DE PARTIDAS DO EVENTO
  late TextEditingController categoryController;
  late TextEditingController durationController;
  late TextEditingController playersPerTeamController;
  late TextEditingController refereerController;
  //CONTROLLERS DE CONFIGURAÇÕES DE PARTIDAS APARTIR DE MODALIDADES == FOOTBALL
  late TextEditingController halvesController;
  late TextEditingController extraTimeController;
  late TextEditingController penaltyController;
  //CONTROLLERS DE CONFIGURAÇÕES DE PARTIDAS APARTIR DE MODALIDADES == VOLLEYBALL
  late TextEditingController setsController;
  late TextEditingController pointsController;
  late TextEditingController tieBreakPointsController;
  //CONTROLLERS DE CONFIGURAÇÕES DE PARTIDAS APARTIR DE MODALIDADES == BASKETBALL
  late TextEditingController quartersController;
  late TextEditingController shotClockController;
  //CONTROLLERS DE PARTICIPANTES DO EVENTO
  late TextEditingController participantsController;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS
  void initConfigTextControllers(EventModel event) {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    titleController = TextEditingController(text: event.title ?? '');
    bioController = TextEditingController(text: event.bio ?? '');
    photoController = TextEditingController(text: event.photo ?? '');
    allowCollaboratorsController = TextEditingController(text: event.collaborators.toString());
    privacyController = TextEditingController(text: event.privacy!.name);
    //CONTROLLERS DE NOTIFICAÇÕES DO EVENTO
    notificationController = TextEditingController(text: 'true');
    //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
    dateController = TextEditingController(text: event.date.toString());
    startTimeController = TextEditingController(text: event.startTime ?? '');
    endTimeController = TextEditingController(text: event.endTime ?? '');
    modalityController = TextEditingController(text: event.modality!.name);
    //CONTROLLERS DE PARTIDAS DO EVENTO
    categoryController = TextEditingController(text: event.gameConfig!.category);
    durationController = TextEditingController(text: event.gameConfig!.duration.toString());
    playersPerTeamController = TextEditingController(text: event.gameConfig!.playersPerTeam.toString());
    pointsController = TextEditingController(text: event.gameConfig!.points.toString());
    refereerController = TextEditingController(text: event.gameConfig!.refereerId.toString());
    //CONTROLLERS DE CONFIGURAÇÕES DE PARTIDA
    initConfigGameControllers(event, modalityController.text);
    //CONTROLLERS DE PARTICIPANTES DO EVENTO
    participantsController = TextEditingController();
  }

  //FUNÇÃO PARA FINALIZAR CONTROLLERS
  void disposeConfigTextControllers() {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    titleController.dispose();
    bioController.dispose();
    photoController.dispose();
    allowCollaboratorsController.dispose();
    privacyController.dispose();
    //CONTROLLERS DE NOTIFICAÇÕES DO EVENTO
    notificationController.dispose();
    //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    modalityController.dispose();
    //CONTROLLERS DE PARTIDAS DO EVENTO
    categoryController.dispose();
    durationController.dispose();
    playersPerTeamController.dispose();
    pointsController.dispose();
    refereerController.dispose();
    //CONTROLLERS DE CONFIGURAÇÕES DE PARTIDA
    disposeConfigGameControllers(modalityController.text);
    //CONTROLLERS DE PARTICIPANTES DO EVENTO
    participantsController.dispose();
  }

  //FUNÇÃO DE DEFINIÇÃO DE CONTROLLERS DE CONFIGURAÇÕES DE PARTIDAS A PARTIR DA MODALIDADE
  void initConfigGameControllers(EventModel event, String modality){
    switch (modality) {
      case "Volleyball":
        setsController = TextEditingController(text: event.gameConfig!.config!["sets"].toString());
        tieBreakPointsController = TextEditingController(text: event.gameConfig!.config!["tieBreakPoints"].toString());
      case "Basketball":
        quartersController = TextEditingController(text: event.gameConfig!.config!["quarters"].toString());
        shotClockController = TextEditingController(text: event.gameConfig!.config!["shotClock"].toString());
        extraTimeController = TextEditingController(text: event.gameConfig!.config!["extraTime"].toString());
      default:
        halvesController = TextEditingController(text: event.gameConfig!.config!["halves"].toString());
        penaltyController = TextEditingController(text: event.gameConfig!.config!["hasPenalty"].toString());
        extraTimeController = TextEditingController(text: event.gameConfig!.config!["extraTime"].toString());
    }
  }
  
  //FUNÇÃO DE REMOVER DE CONTROLLERS DE CONFIGURAÇÕES DE PARTIDAS A PARTIR DA MODALIDADE
  void disposeConfigGameControllers(String modality){
    switch (modality) {
      case "Volleyball":
        setsController.dispose();
        tieBreakPointsController.dispose();
      case "Basketball":
        quartersController.dispose();
        shotClockController.dispose();
        extraTimeController.dispose();
      default:
        halvesController.dispose();
        penaltyController.dispose();
        extraTimeController.dispose();
    }
  }

  //FUNÇÃO DE MONTAGEM DE MAP DE CONFIGURAÇÕES DE PARTIDA A PARTIR DA MODALIDADE
  Map<String, dynamic> setExtraConfigGame(String modality){
    switch (modality) {
      case "Volleyball":
        return {
          "sets" : int.parse(setsController.text),
          "tieBreakPoints" : bool.parse(tieBreakPointsController.text),
        };
      case "Basketball":
        return {
          "quarters" : int.parse(quartersController.text),
          "shotClock" : int.parse(shotClockController.text),
        };
      default:
        return {
          "halves" : int.parse(halvesController.text),
          "penalty" : bool.parse(penaltyController.text),
        }; 
    }
  }

  //FUNÇÃO DE MONTAGEM DE OBJETO DE CONFIGURAÇÕES DA PARTIDA
  GameConfigModel setGameConfigEvent(){
    final eventController = this as EventController;
    return GameConfigModel(
      category: eventController.categoryController.text,
      eventId: eventController.event.id!,
      duration: int.parse(durationController.text),
      points: int.parse(pointsController.text),
      playersPerTeam: int.parse(playersPerTeamController.text),
      refereerId: int.parse(refereerController.text),
      config: setExtraConfigGame(eventController.modalityController.text)
    );
  }

  //FUNÇÃO DE ENVIO DE FORMULARIO
  Future<Map<String, dynamic>> sendConfigEvent() async {
    try {  
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
