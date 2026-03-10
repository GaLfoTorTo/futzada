import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/models/game_config_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

//===MIXIN - CONFIGURAÇÕES DAS PARTIDAS===
mixin GameConfigMixin on GetxController implements GameBase{
  //CONTROLLERS DE CAMPOS DE CONFIGURAÇÕES
  late TextEditingController numberController;
  late TextEditingController categoryController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController durationController;
  late TextEditingController hasTwoHalvesController;
  late TextEditingController hasExtraTimeController;
  late TextEditingController hasPenaltyController;
  late TextEditingController hasGoalLimitController;
  late TextEditingController hasRefereerController;
  late TextEditingController playersPerTeamController;
  late TextEditingController extraTimeController;
  late TextEditingController goalLimitController;
  late UserModel? refereerController;
  //CONTROLADORES DE CAMPOS DE EQUIPE
  late TextEditingController teamANameController;
  late TextEditingController teamAEmblemaController;
  late TextEditingController teamBNameController;
  late TextEditingController teamBEmblemaController;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS DE TEXTO
  void initTextControllers() {
    numberController = TextEditingController(text: currentGame.number.toString());
    categoryController = TextEditingController(text: event!.gameConfig!.category);
    startTimeController = TextEditingController(text: DateFormat.Hm().format(currentGame.startTime!));
    endTimeController = TextEditingController(text: DateFormat.Hm().format(currentGame.endTime!));
    durationController = TextEditingController(text: event!.gameConfig?.duration.toString() ?? '');
    playersPerTeamController = TextEditingController(text: currentGameConfig!.playersPerTeam.toString());
    hasTwoHalvesController = TextEditingController(text: currentGameConfig!.config!['hasTwoHalves'].toString());
    hasExtraTimeController = TextEditingController(text: currentGameConfig!.config!['hasExtraTime'].toString());
    hasPenaltyController = TextEditingController(text: currentGameConfig!.config!['hasPenalty'].toString());
    hasGoalLimitController = TextEditingController(text: currentGameConfig!.config!['hasGoalLimit'].toString());
    hasRefereerController = TextEditingController(text: currentGameConfig!.config!['hasRefereer'].toString());
    extraTimeController = TextEditingController(text: currentGameConfig!.config!['extraTime'].toString());
    goalLimitController = TextEditingController(text: currentGameConfig!.config!['goalLimit'].toString());
    refereerController = event!.participants!.firstWhere((u) => u.id == currentGame.refereeId);
  }

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS DE EQUIPES
  void initTeamsControllers(){
    teamANameController = TextEditingController(text: currentGame.teams?.first.name?.toString() ?? '');
    teamBNameController = TextEditingController(text: currentGame.teams?.last.name?.toString() ?? '');
    teamAEmblemaController = TextEditingController(text: currentGame.teams?.first.emblem?.toString() ?? 'emblema_1');
    teamBEmblemaController = TextEditingController(text: currentGame.teams?.last.emblem?.toString() ?? 'emblema_2');
  }

  //FUNÇÃO PARA FINALIZAR CONTROLLERS DE TEXTO
  void disposeTextControllers(){
    numberController.dispose();
    categoryController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    durationController.dispose();
    hasTwoHalvesController.dispose();
    hasExtraTimeController.dispose();
    hasPenaltyController.dispose();
    hasGoalLimitController.dispose();
    hasRefereerController.dispose();
    playersPerTeamController.dispose();
    extraTimeController.dispose();
    goalLimitController.dispose();
    goalLimitController.dispose();
  }

  //FUNÇÃO PARA FINALIZAR CONTROLLERS DE EQUIPES
  void disposeTeamsControllers(){
    teamANameController.dispose();
    teamBNameController.dispose();
    teamAEmblemaController.dispose();
    teamBEmblemaController.dispose();
  }

  //FUNÇÃO DE DEFINIÇÃO DE CONFIGURAÇÕES DA PARTIDA
  void setGameConfig() {
    //RESGATAR INSTANCIA DO CONTROLLER
    GameController gameController = this as GameController;
    //ATUALIZAR CONFIGURAÇÕES DE PARTIDA
    gameController.currentGameConfig = GameConfigModel(
      id: currentGameConfig!.id,
      eventId: event!.id!,
      category: categoryController.text,
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
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
    //SALVAR CONFIGURAÇÕES DO EVENTO
    event!.gameConfig = gameController.currentGameConfig;
    //EXIBIR MENSAGEM DE SUCESSO
    AppHelper.feedbackMessage(Get.context, "Configurações Salvas com sucesso", type: "Success");
  }

  //FUNÇÃO PARA VERIFICAR SE PARTIDA ESTA CONFIGURADA PARA INICIAR
  bool checkGame(GameModel? game){
    //RESGATAR INSTANCIA DO CONTROLLER
    GameController gameController = GameController.instance;
    //VERIFICAR SE PARTIDA ESTA COM AS CONFIGURAÇÕES DEFINIDAS
    if(gameController.currentGameConfig == null){
      //VERIFICAR SE EQUIPES DA PARTIDA ESTÃO DEFINIDAS
      if (game!.teams?.length == 2) {
        final playersA = game.teams![0].players;
        final playersB = game.teams![1].players;
        //VERIFICAR SE AS DUAS EQUIPES TEM A MESMA QUANTIDADE DE JOGADORES
        return playersA.isNotEmpty && playersB.isNotEmpty && playersA.length == playersB.length;
      }
      return false;
    }
    return false;
  }
}