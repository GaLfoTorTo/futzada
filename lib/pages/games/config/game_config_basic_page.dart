import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/inputs/input_switch_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_icon_widget.dart';

class GameConfigBasicPage extends StatefulWidget {
  const GameConfigBasicPage({super.key});

  @override
  State<GameConfigBasicPage> createState() => _GameConfigBasicPageState();
}

class _GameConfigBasicPageState extends State<GameConfigBasicPage> {
  //RESGATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //RESGATAR EVENTO DA PARTIDA
  EventModel event = EventController.instance.event;
  //DEFINIR CONFIGURAÇÕES DE PARTIDA DO EVENTO
  late GameConfigModel gameConfig;
  //CONTROLADOR DE EXIBIÇÃO DE CAMPOS
  bool hasRefereer = false;
  bool hasGoalLimit = false;
  bool hasExtraTime = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //REDEFINIR HORARIOS DE ACORDO COM DURAÇÃO
    setDuration(gameController.durationController.text);
    //RESGATAR VALORES DEFINIDOS NAS CONFIGURAÇÕES
    hasRefereer = bool.parse(gameController.hasRefereerController.text);
    hasGoalLimit = bool.parse(gameController.hasGoalLimitController.text);
    hasExtraTime = bool.parse(gameController.hasExtraTimeController.text);
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Configurações básicas',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AppColors.green_300
              ),
            ),
          ),
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
              onChanged: (value) => gameController.event.gameConfig!.extraTime = int.parse(value),
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
              onChanged: (value) => gameController.event.gameConfig!.goalLimit = int.parse(value),
            ),
          ],
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
              items: List.generate(event.participants!.length, (i){
                return {
                  'id': event.participants![i].user.id,
                  'title': "${event.participants![i].user.firstName} ${event.participants![i].user.lastName}",
                  'photo': event.participants![i].user.photo,
                };
              }),
            ),
          ],
        ]
      ),
    );
  }
}