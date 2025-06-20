import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/models/game_config_model.dart';
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
  //DEFINIR CONFIGURAÇÕES DE PARTIDA DO EVENTO
  late GameConfigModel gameConfig;
  //DEFINIR CONTROLADORES DE TEXTO 
  late TextEditingController numberController;
  late TextEditingController categoryController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController durationController;
  late TextEditingController goalLimitController;
  late ParticipantModel? refereerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //RESGATAR CONFIGURAÇÕES DE PARTIDA DO EVENTO
    gameConfig = gameController.event.gameConfig!;
    //RESGATAR VALORES DE CAMPO DE TEXTO 
    numberController = TextEditingController(text: gameController.currentGame.number.toString());
    categoryController = TextEditingController(text: gameController.event.category);
    startTimeController = TextEditingController(text: DateFormat.Hm().format(gameController.currentGame.startTime!).toString());
    endTimeController = TextEditingController(text: DateFormat.Hm().format(gameController.currentGame.endTime!).toString());
    durationController = TextEditingController(text: gameController.event.gameConfig!.duration.toString());
    goalLimitController = TextEditingController(text: gameController.event.gameConfig!.goalLimit.toString());
    refereerController = gameController.currentGame.referee;
    //REDEFINIR HORARIOS DE ACORDO COM DURAÇÃO
    setDuration(durationController.text);
  }

  //FUNÇÃO PARA AJUSTAR DATA DE INICIO, FIM E DURAÇÃO DE PARTIDA
  void setDuration(String? duration){
    //VERIFICAR SE DURAÇÃO NÃO ESTA VAZIA
    if(duration != null){
      setState(() {
        //RESGATAR CONFIGURAÇÃO DE 2 TEMPOS
        var totalDuration = gameController.currentGameConfig!.hasTwoHalves! ? int.parse(duration) * 2 : int.parse(duration);
        //REDEFINIR DATA DE INICIO E FIM DA PARTIDA
        var endTime = gameController.currentGame.startTime!.add(Duration(minutes: totalDuration));
        //ATUALIZAR HORARIO DE FIM DA PARTIDA
        gameController.currentGame.endTime = endTime;
        //ATUALIZAR TEXTO DO INPUT
        endTimeController.text = DateFormat.Hm().format(endTime).toString();
      });
    }
  }

  //FUNÇÃO PARA SALVAR CONFIGURAÇÕES 
  void saveConfigGame(){
    //RESGATAR DURAÇÃO TOTAL DA PARTIDA
    var totalDuration = gameController.currentGameConfig!.hasTwoHalves! 
      ? int.parse(durationController.text) * 2 
      : int.parse(durationController.text);
    //ATUALIZAR MAP DE PARTIDA ATUAL NO CONTROLLER
    gameController.currentGame.copyWith(
      id : gameController.currentGame.id,
      number : gameController.currentGame.number,
      event : gameController.currentGame.event,
      referee : refereerController,
      duration : int.parse(durationController.text),
      startTime : DateFormat.Hm().parse(startTimeController.text),
      endTime : gameController.currentGame.startTime!.add(Duration(minutes: totalDuration)),
      status : gameController.currentGame.status,
      result : gameController.currentGame.result,
      teams : gameController.currentGame.teams,
      createdAt : DateTime.now(),
      updatedAt : DateTime.now(),
    );
  }

  @override
  void dispose() {
    //DEFINIR CONFIGURAÇÕES PREENCHIDAS PELO USUARIO
    saveConfigGame();
    super.dispose();
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
                  padding: EdgeInsets.only(right: 10),
                  child: InputTextWidget(
                    name: 'number',
                    label: 'Nº',
                    initialValue: gameController.currentGame.number.toString(),
                    disabled: true,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InputTextWidget(
                    name: 'category',
                    label: 'Categoria',
                    initialValue: gameController.event.category,
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
              label: gameController.event.gameConfig!.hasTwoHalves != null && gameController.event.gameConfig!.hasTwoHalves! 
                ? "Duração (min. por tempo)" 
                : "Duração (min.)",
              prefixIcon: Icons.timer_outlined,
              textController: durationController,
              controller: gameController,
              type: TextInputType.number,
              onChanged: (value) => setDuration(value),
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
              value: gameController.event.gameConfig!.hasTwoHalves!,
              onChanged: (value){
                setState(() {
                  //ATUALIZAR VALOR DO SWITCH
                  gameController.event.gameConfig!.hasTwoHalves = value;
                  //RECLACULAR PERIODO DE PARTIDA
                  setDuration(durationController.text);
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
              value: gameController.event.gameConfig!.hasExtraTime!,
              onChanged: (value){
                setState(() {
                  gameController.event.gameConfig!.hasExtraTime = value;
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
              value: gameController.event.gameConfig!.hasPenalty!,
              onChanged: (value){
                setState(() {
                  gameController.event.gameConfig!.hasPenalty = value;
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
              value: gameController.event.gameConfig!.hasGoalLimit!,
              onChanged: (value){
                setState(() {
                  gameController.event.gameConfig!.hasGoalLimit = value;
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
          if(gameController.event.gameConfig!.hasGoalLimit != null && gameController.event.gameConfig!.hasGoalLimit!)...[
            InputTextWidget(
              name: 'limitGols',
              label: 'Qtd. Gols',
              prefixIcon: AppIcones.futbol_ball_outline,
              textController: goalLimitController,
              controller: gameController,
              type: TextInputType.number,
              onChanged: (value) => gameController.event.gameConfig!.goalLimit = int.parse(value),
            ),
          ],
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.only(top:20, bottom: 40),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: SwitchListTile(
              value: gameController.event.gameConfig!.hasRefereer!,
              onChanged: (value) {
                setState(() {
                  gameController.currentGameConfig!.hasRefereer = value;
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
          if(gameController.event.gameConfig!.hasRefereer != null && gameController.event.gameConfig!.hasRefereer!)...[
            ButtonDropdownIconWidget(
              width: dimensions.width,
              menuWidth: dimensions.width, 
              menuHeight: 200,
              color: AppColors.white,
              iconAfter: false,
              iconSize: 30,
              textSize: AppSize.fontMd,
              onChange: (newValue) {
                setState(() {
                  //DEFINIR ARBITRO DA PARTIDA
                  gameController.event.gameConfig!.hasRefereer = newValue;
                  gameController.currentGame.referee = newValue;
                });
              },
              selectedItem: event.participants![0].id,
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