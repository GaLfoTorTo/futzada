import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/models/event_model.dart';
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
                    textController: gameController.numberController,
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
                    textController: gameController.categoryController,
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
                    textController: gameController.startTimeController,
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
                    textController: gameController.endTimeController,
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
              label: bool.parse(gameController.hasTwoHalvesController.text)
                ? "Duração (min. por tempo)" 
                : "Duração (min.)",
              prefixIcon: Icons.timer_outlined,
              textController: gameController.durationController,
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
              value: bool.parse(gameController.hasTwoHalvesController.text),
              onChanged: (value){
                setState(() {
                  //ATUALIZAR VALOR DO SWITCH
                  gameController.hasTwoHalvesController.text = value.toString();
                  //RECLACULAR PERIODO DE PARTIDA
                  setDuration(gameController.durationController.text);
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
              value: bool.parse(gameController.hasExtraTimeController.text),
              onChanged: (value){
                setState(() {
                  //ATUALIZAR VALOR 
                  gameController.hasTwoHalvesController.text = value.toString();
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
          if(hasExtraTime)...[
            InputTextWidget(
              name: 'extra_time',
              label: 'Tempo Prorrogação',
              prefixIcon: AppIcones.futbol_ball_outline,
              textController: gameController.extraTimeController,
              controller: gameController,
              type: TextInputType.number,
              onChanged: (value) => gameController.event.gameConfig!.extraTime = int.parse(value),
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
              value: bool.parse(gameController.hasPenaltyController.text),
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
              value: bool.parse(gameController.hasGoalLimitController.text),
              onChanged: (value){
                setState(() {
                  hasGoalLimit = value;
                  gameController.hasGoalLimitController.text = value.toString();
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
                AppIcones.futebol_ball_solid,
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
              textController: gameController.goalLimitController,
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
              value: bool.parse(gameController.hasRefereerController.text),
              onChanged: (value) {
                setState(() {
                  hasRefereer = value;
                  gameController.hasRefereerController.text = value.toString();
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