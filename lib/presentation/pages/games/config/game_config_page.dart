import 'package:futzada/core/utils/user_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_size.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_switch_widget.dart';
import 'package:futzada/presentation/widget/inputs/silder_players_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_outline_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_dropdown_icon_widget.dart';

class GameConfigPage extends StatefulWidget {
  final GameModel? game;
  const GameConfigPage({
    super.key,
    this.game
  });

  @override
  State<GameConfigPage> createState() => _GameConfigPageState();
}

class _GameConfigPageState extends State<GameConfigPage> {
  //CONTROLLER - PARTIDA
  GameController gameController = GameController.instance;
  //ESTADOS - CONFIGURAÇÕES DE CAMPOS
  bool hasRefereer = false;
  bool hasGoalLimit = false;
  bool hasExtraTime = false;
  late int qtdPlayers;
  late int minPlayers;
  late int maxPlayers;
  late int divisions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ADICIONAR PARTIDA RECEBIDA POR ARGUMENTO COMO JOGO ATUAL NO CONTROLLER
    gameController.currentGame = Get.arguments['game'];
    //INICIARLIZAR CONTROLLERS DE TEXTO
    gameController.initTextControllers();
    //REDEFINIR HORARIOS DE ACORDO COM DURAÇÃO
    setDuration(gameController.durationController.text);
    //RESGATAR VALORES DEFINIDOS NAS CONFIGURAÇÕES
    hasRefereer = bool.parse(gameController.hasRefereerController.text);
    hasGoalLimit = bool.parse(gameController.hasGoalLimitController.text);
    hasExtraTime = bool.parse(gameController.hasExtraTimeController.text);
    //INICIALIZAR VALORES DE SLIDER (QTD DE JOGADORES)
    qtdPlayers = gameController.playersPerTeamController.text.isNotEmpty 
      ? int.parse(gameController.playersPerTeamController.text) 
      : gameController.gameService.getQtdPlayers(gameController.categoryController.text)['minPlayers']!;
    minPlayers = gameController.gameService.getQtdPlayers(gameController.categoryController.text)['minPlayers']!;
    maxPlayers = gameController.gameService.getQtdPlayers(gameController.categoryController.text)['maxPlayers']!;
    divisions = gameController.gameService.getQtdPlayers(gameController.categoryController.text)['divisions']!;
  }

  //FUNÇÃO PARA AJUSTAR DATA DE INICIO, FIM E DURAÇÃO DE PARTIDA
  void setDuration(String? duration){
    //VERIFICAR SE DURAÇÃO NÃO ESTA VAZIA
    if(duration != null){
      setState(() {
        //RESGATAR CONFIGURAÇÃO DE 2 TEMPOS
        var totalDuration = bool.parse(gameController.hasTwoHalvesController.text) ? int.parse(duration) * 2 : int.parse(duration);
        //REDEFINIR DATA DE INICIO E FIM DA PARTIDA
        var endTime = gameController.currentGame.startTime!.add(Duration(minutes: totalDuration));
        //ATUALIZAR HORARIO DE FIM DA PARTIDA
        gameController.currentGame.endTime = endTime;
        //ATUALIZAR TEXTO DO INPUT
        gameController.endTimeController.text = DateFormat.Hm().format(endTime).toString();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: HeaderWidget(
        title: "Configurações da Partida",
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColors.green_300,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark_500.withAlpha(50),
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "As configurações da partida determinam como as partidas da pelada funcionam, duração de tempos, limites de gols, arbitragem, dentre outros. Essas configurações podem ser ajustadas antes do início de uma nova partida.",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.blue_500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InputTextWidget(
                              name: 'number',
                              label: 'Nº',
                              textController: gameController.numberController,
                              enable: false,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: InputTextWidget(
                            name: 'category',
                            label: 'Categoria',
                            textController: gameController.categoryController,
                            enable: false,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InputTextWidget(
                              name: 'startTime',
                              label: 'Início',
                              prefixIcon: Icons.access_time_rounded,
                              textController: gameController.startTimeController,
                              enable: false,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InputTextWidget(
                            name: 'endTime',
                            label: 'Fim',
                            prefixIcon: Icons.access_time_rounded,
                            textController: gameController.endTimeController,
                            type: TextInputType.text,
                            enable: false,
                          ),
                        ),
                      ],
                    ),
                    InputTextWidget(
                      name: 'duration',
                      label: bool.parse(gameController.hasTwoHalvesController.text)
                        ? "Duração (min. por tempo)" 
                        : "Duração (min.)",
                      prefixIcon: Icons.timer_outlined,
                      textController: gameController.durationController,
                      type: TextInputType.number,
                      onChanged: (value) => setDuration(value),
                    ),
                    InputSwitchWidget(
                      name: "dois_tempos", 
                      label: "Dois Tempos", 
                      prefixIcon: Icons.safety_divider_rounded,
                      value: bool.parse(gameController.hasTwoHalvesController.text), 
                      textController: gameController.hasTwoHalvesController,
                      onChanged: (value){
                        setState(() {
                          gameController.hasTwoHalvesController.text = value.toString();
                        });
                      },
                    ),
                    InputSwitchWidget(
                      name: "prorrogacao", 
                      label: "Prorrogação", 
                      prefixIcon: Icons.more_time_rounded,
                      value: bool.parse(gameController.hasExtraTimeController.text), 
                      textController: gameController.hasExtraTimeController,
                      onChanged: (value){
                        setState(() {
                          //ATUALIZAR VALOR 
                          hasExtraTime = value;
                          gameController.hasExtraTimeController.text = value.toString();
                        });
                      },
                    ),
                    if(hasExtraTime)...[
                      InputTextWidget(
                        name: 'extra_time',
                        label: 'Tempo Prorrogação',
                        prefixIcon: Icons.timer_outlined,
                        textController: gameController.extraTimeController,
                        type: TextInputType.number,
                        onChanged: (value) => gameController.event.gameConfig!.config!["extraTime"] = int.parse(value),
                      ),
                    ],
                    InputSwitchWidget(
                      name: "penaltis", 
                      label: "Pênaltis", 
                      prefixIcon: Icons.sports,
                      value: bool.parse(gameController.hasPenaltyController.text), 
                      textController: gameController.hasPenaltyController,
                      onChanged: (value){
                        setState(() {
                          gameController.hasPenaltyController.text = value.toString();
                        });
                      },
                    ),
                    InputSwitchWidget(
                      name: "limit_goals", 
                      label: "Limite de Gols", 
                      prefixIcon: Icons.scoreboard_outlined,
                      value: bool.parse(gameController.hasGoalLimitController.text), 
                      textController: gameController.hasGoalLimitController,
                      onChanged: (value){
                        setState(() {
                          //ATUALIZAR VALOR 
                          hasGoalLimit = value;
                          gameController.hasGoalLimitController.text = value.toString();
                        });
                      },
                    ),
                    if(hasGoalLimit)...[
                      InputTextWidget(
                        name: 'limitGols',
                        label: 'Qtd. Gols',
                        prefixIcon: Icons.sports_soccer_rounded,
                        textController: gameController.goalLimitController,
                        type: TextInputType.number,
                        onChanged: (value) => gameController.event.gameConfig!.config!["goalLimit"] = int.parse(value),
                      ),
                    ],
                    SilderPlayersWidget(
                      qtdPlayers: qtdPlayers.toDouble(),
                      minPlayers: minPlayers.toDouble(),
                      maxPlayers: maxPlayers.toDouble(),
                      divisions: divisions,
                      onChange: (value){
                        setState(() {
                          //ATUALIZAR VALOR 
                          qtdPlayers = value.floor();
                          gameController.playersPerTeamController.text = value.floor().toString();
                        });
                      },
                    ),
                    InputSwitchWidget(
                      name: "refeer", 
                      label: "Árbitro", 
                      prefixIcon: Icons.sports,
                      value: bool.parse(gameController.hasRefereerController.text), 
                      textController: gameController.hasRefereerController,
                      onChanged: (value){
                        setState(() {
                          //ATUALIZAR VALOR 
                          hasRefereer = value;
                          gameController.hasRefereerController.text = value.toString();
                        });
                      },
                    ),
                    if(hasRefereer)...[
                      ButtonDropdownIconWidget(
                        width: dimensions.width,
                        menuWidth: dimensions.width - 20, 
                        menuHeight: 200,
                        backgroundColor: Get.isDarkMode ? AppColors.dark_300 : AppColors.white,
                        iconAfter: false,
                        iconSize: 30,
                        textSize: AppSize.fontMd,
                        onChange: (newValue) {
                          setState(() {
                            //DEFINIR ARBITRO DA PARTIDA
                            gameController.refereerController = newValue;
                          });
                        },
                        selectedItem: gameController.refereerController!.id,
                        items: List.generate(gameController.event.participants!.length, (i){
                          return {
                            'id': gameController.event.participants![i].id,
                            'title': UserUtils.getFullName(gameController.event.participants![i]),
                            'photo': gameController.event.participants![i].photo,
                          };
                        }),
                      ),
                    ],
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonOutlineWidget(
                      text: "Voltar",
                      width: 100,
                      action: () => Get.back()
                    ),
                    ButtonTextWidget(
                      text: "Salvar",
                      icon: Icons.save,
                      width: 100,
                      action: () => {
                        gameController.setGameConfig(),
                        gameController.disposeTextControllers(),
                        Get.previousRoute == "/games/overview" ? Get.offAndToNamed("/games/overview") : Get.offAndToNamed("/games/teams")
                      }
                    ),
                  ],
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}