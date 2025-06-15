import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/widget/buttons/button_dropdown_icon_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';

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
  //DEFINIR PARTIDA ATUAL
  late GameModel game;
  //DEFINIR CONFIGURAÇÕES DE PARTIDA DO EVENTO
  late GameConfigModel gameConfig;
  //DEFINIR CONTROLADORES DE TEXTO 
  late TextEditingController numberController;
  late TextEditingController categoryController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController durationController;
  late TextEditingController goalLimitController;
  //DEFINIR CONTROLADORES DE SWITCH
  late bool hasTwoHalves;
  late bool hasExtraTime;
  late bool hasPenalty;
  late bool hasGoalLimit;
  late bool hasRefereer;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //RESGATAR CONFIGURAÇÕES DE PARTIDA DO EVENTO
    gameConfig = gameController.event!.gameConfig!;
    //RESGATAR PARTIDA ATUAL
    game = gameController.currentGame!;
    //RESGATAR VALORES DE CAMPO DE TEXTO 
    numberController = TextEditingController(text: "#${game.number.toString()}");
    categoryController = TextEditingController(text: gameConfig.category.toString());
    startTimeController = TextEditingController(text: DateFormat.Hm().format(game.startTime!).toString());
    endTimeController = TextEditingController(text: DateFormat.Hm().format(game.endTime!).toString());
    durationController = TextEditingController(text: gameConfig.duration.toString());
    goalLimitController = TextEditingController(text: gameConfig.goalLimit.toString());
    //RESGATAR VALORES DE CAMPO DE SWITCH
    hasTwoHalves = gameConfig.hasTwoHalves!;
    hasExtraTime = gameConfig.hasExtraTime!;
    hasPenalty = gameConfig.hasPenalty!;
    hasGoalLimit = gameConfig.hasGoalLimit!;
    hasRefereer = gameConfig.hasRefereer!;
  }
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
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
                    textController: numberController,
                    controller: gameController,
                    disabled: true,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: InputTextWidget(
                    name: 'category',
                    label: 'Categoria',
                    textController: categoryController,
                    controller: gameController,
                    type: TextInputType.text,
                    disabled: true,
                  ),
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
                    textController: startTimeController,
                    controller: gameController,
                    disabled: true,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: InputTextWidget(
                    name: 'endTime',
                    label: 'Fim',
                    prefixIcon: Icons.access_time_rounded,
                    textController: endTimeController,
                    controller: gameController,
                    type: TextInputType.text,
                    disabled: true,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InputTextWidget(
              name: 'duration',
              label: hasTwoHalves ? "Duração (min. por tempo)" : "Duração (min.)",
              prefixIcon: Icons.timer_outlined,
              textController: durationController,
              controller: gameController,
              type: TextInputType.number,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: SwitchListTile(
              value: hasTwoHalves,
              onChanged: (value){
                setState(() {
                  hasTwoHalves = value;
                });
              },
              activeColor: AppColors.green_300,
              inactiveTrackColor: AppColors.gray_300,
              inactiveThumbColor: AppColors.gray_500,
              title: Text(
                'Dois Tempos',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
              ),
              secondary: const Icon(
                Icons.safety_divider_rounded,
                color: AppColors.gray_500,
                size: 30,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: SwitchListTile(
              value: hasExtraTime,
              onChanged: (value){
                setState(() {
                  hasExtraTime = value;
                });
              },
              activeColor: AppColors.green_300,
              inactiveTrackColor: AppColors.gray_300,
              inactiveThumbColor: AppColors.gray_500,
              title: Text(
                'Prorrogação',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
              ),
              secondary: const Icon(
                Icons.more_time_rounded,
                color: AppColors.gray_500,
                size: 30,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: SwitchListTile(
              value: hasPenalty,
              onChanged: (value){
                setState(() {
                  hasPenalty = value;
                });
              },
              activeColor: AppColors.green_300,
              inactiveTrackColor: AppColors.gray_300,
              inactiveThumbColor: AppColors.gray_500,
              title: Text(
                'Pênaltis',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
              ),
              secondary: SvgPicture.asset(
                AppIcones.chuteiras['campo']!,
                width: 25,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray_500,
                  BlendMode.srcIn
                ),
              )
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: SwitchListTile(
              value: hasGoalLimit,
              onChanged: (value){
                setState(() {
                  hasGoalLimit = value;
                });
              },
              activeColor: AppColors.green_300,
              inactiveTrackColor: AppColors.gray_300,
              inactiveThumbColor: AppColors.gray_500,
              title: Text(
                'Limite de Gols',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
              ),
              secondary: const Icon(
                AppIcones.futbol_ball_solid,
                color: AppColors.gray_500,
                size: 25,
              ),
            ),
          ),
          if(hasGoalLimit)...[
            InputTextWidget(
              name: 'limitGols',
              label: 'Qtd. Gols',
              prefixIcon: AppIcones.futbol_ball_outline,
              textController: goalLimitController,
              controller: gameController,
              type: TextInputType.number,
            ),
          ],
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: SwitchListTile(
              value: hasRefereer,
              onChanged: (value){
                setState(() {
                  hasRefereer = value;
                });
              },
              activeColor: AppColors.green_300,
              inactiveTrackColor: AppColors.gray_300,
              inactiveThumbColor: AppColors.gray_500,
              title: Text(
                'Árbitro',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
              ),
              secondary: const Icon(
                AppIcones.apito,
                color: AppColors.gray_500,
              ),
            ),
          ),
          if(hasRefereer)...[
            ButtonDropdownIconWidget(
              width: dimensions.width,
              menuWidth: dimensions.width, 
              menuHeight: 200,
              color: AppColors.white,
              iconAfter: false,
              iconSize: 30,
              textSize: AppSize.fontMd,
              onChange: (newValue) {},
              selectedItem: event.participants![0].user.id, 
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