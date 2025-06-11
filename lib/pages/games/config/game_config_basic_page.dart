import 'package:flutter/material.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/widget/buttons/button_dropdown_icon_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:intl/intl.dart';

class GameConfigBasicPage extends StatefulWidget {
  final GameModel game;
  const GameConfigBasicPage({
    super.key,
    required this.game
  });

  @override
  State<GameConfigBasicPage> createState() => _GameConfigBasicPageState();
}

class _GameConfigBasicPageState extends State<GameConfigBasicPage> {
  //RESHATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //RESGATAR EVENTO DA PARTIDA
  EventModel event = EventController.instance.event;
  //CAMPOS DE PROPRIEDADES DA PARTIDA
  Map<String, Map<String, dynamic>> gameConfig = {
    'number' : {
      'name': 'Nº',
      'value' : ''
    },
    'category': {
      'name': 'Categoria',
      'value' : ''
    },
    'qtdPlayers': {
      'name': 'Qtd. Jogadores (Por equipe)',
      'value' : ''
    },
    'duration' : {
      'name': 'Duração da partida',
      'value' : ''
    },
    'startTime' : {
      'name': 'Previsão de Início',
      'value' : ''
    },
    'endTime' : {
      'name': 'Previsão de Fim',
      'value' : ''
    },
    'referee' : {
      'name': 'Árbitro',
      'value' : ''
    },
  };
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR CONTROLLERS DE CAMPOS DE CONFIGURAÇÃO DA PARTIDA
    final TextEditingController numberController = TextEditingController(text: "#${widget.game.number.toString()}");
    final TextEditingController categoryController = TextEditingController(text: event.category.toString());
    final TextEditingController durationController = TextEditingController(text: widget.game.duration.toString());
    final TextEditingController startTimeController = TextEditingController(text: DateFormat.Hm().format(widget.game.startTime!).toString());
    final TextEditingController endTimeController = TextEditingController(text: DateFormat.Hm().format(widget.game.endTime!).toString());
    final TextEditingController qtdPlayersController = TextEditingController(text: event.qtdPlayers.toString());
    final TextEditingController allowColaboratorsController = TextEditingController(text: event.allowCollaborators.toString());
    //LISTA DE QTD DE JOGADORES POR EQUIPE DE ACORDO COM A CATEGORIA DO EVENTO
    double qtdPlayers = event.qtdPlayers!.toDouble();
    double minPlayers = 9;
    double maxPlayers = 11;
    int divisions = 2;
    //SELECIONAR TIPO DE CAMPO
    if(event.category == 'Futebol'){
      //DEFINIR VALOR PARA SLIDER
      qtdPlayers = 11;
      minPlayers =  9;
      maxPlayers = 11;
      divisions = 2;
    }else if(event.category == 'Fut7'){
      //DEFINIR VALOR PARA SLIDER
      qtdPlayers = 6;
      minPlayers = 4;
      maxPlayers = 8;
      divisions = 4;
    }else if(event.category == 'Futsal'){
      //DEFINIR VALOR PARA SLIDER
      qtdPlayers = 5;
      minPlayers = 4;
      maxPlayers = 6;
      divisions = 2;
    }
    
    return Container(
      width: dimensions.width,
      height: double.maxFinite,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InputTextWidget(
              name: 'duration',
              label: 'Duração (min)',
              prefixIcon: AppIcones.stopwatch_outline,
              textController: durationController,
              controller: gameController,
              type: TextInputType.number,
            ),
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
                    prefixIcon: AppIcones.clock_outline,
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
                    prefixIcon: AppIcones.clock_outline,
                    textController: endTimeController,
                    controller: gameController,
                    type: TextInputType.text,
                    disabled: true,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Nº de Jogadores (Por time)",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Slider(
                  value: qtdPlayers.toDouble(),
                  min: minPlayers.toDouble(),
                  max: maxPlayers.toDouble(),
                  divisions: divisions,
                  label: qtdPlayers.toInt().toString(),
                  activeColor: AppColors.green_300,
                  inactiveColor: AppColors.white,
                  onChanged: (double newValue) {
                    setState(() {
                      qtdPlayersController.text = newValue.toString();
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    qtdPlayersController.text,
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ),
              ],
            )
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: SwitchListTile(
              value: event.allowCollaborators!,
              onChanged: (value){
                setState(() {
                  allowColaboratorsController.text = value.toString();
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
                color: AppColors.dark_300,
              ),
            ),
          ),
          if(true)...[
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
          ]
        ]
      ),
    );
  }
}