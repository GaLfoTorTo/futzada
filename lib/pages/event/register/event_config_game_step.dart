import 'package:flutter/foundation.dart';
import 'package:futzada/services/game_service.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/widget/inputs/silder_players_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/controllers/event_controller.dart';

class EventConfigGameStep extends StatefulWidget {  
  const EventConfigGameStep({super.key});

  @override
  State<EventConfigGameStep> createState() => EventConfigGameStepState();
}

class EventConfigGameStepState extends State<EventConfigGameStep> {
  //RESGATAR CONTROLLER DE NAVEGAÇÃO
  NavigationController navigationController = NavigationController.instance;
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //INSTANCIAR SERVIÇO DE PARTIDAS
  GameService gameService = GameService();
  //DEFINIR FORMKEY
  final formKey = GlobalKey<FormState>();
  //DEFINIR CATEGORIAS
  List<String> categories = [
    "Futebol",
    "Fut7",
    "Futsal",
  ];
  //DEFINIR VARIAVEIS DE CONTROLLE DE SLIDER
  int qtdPlayers = 11;
  int minPlayers = 9;
  int maxPlayers = 11;
  int divisions = 3;

  //CONTROLADOR DE EXIBIÇÃO DE CAMPOS
  bool hasRefereer = false;
  bool hasGoalLimit = false;
  bool hasExtraTime = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //RESGATAR VALORES DEFINIDOS NAS CONFIGURAÇÕES
    hasRefereer = bool.parse(eventController.hasRefereerController.text);
    hasGoalLimit = bool.parse(eventController.hasGoalLimitController.text);
    hasExtraTime = bool.parse(eventController.hasExtraTimeController.text);
  }

  //FUNÇÃO PARA RESGATAR ICONE DA CATEGORIA
  IconData getIconCategory(key){
    switch (key) {
      case "Futebol":
        return AppIcones.foot_futebol_solid;
      case "Fut7":
        return AppIcones.foot_fut7_solid;
      case "Futsal":
        return AppIcones.foot_futsal_solid;
      default:
        return AppIcones.foot_futebol_solid;
    }
  }

  //FUNÇÃO PARA DEFINIR QUANTIDADE DE JOGADOR POR EQUIPE 
  void setPlayersPerTime(category){
    setState(() {
      //RESGATAR VALORES POR CATEGORIA
      final mapPlayers = gameService.getQtdPlayers(category);
      //ATUALIZAR ESTADOS
      qtdPlayers = mapPlayers['qtdPlayers']!;
      minPlayers = mapPlayers['minPlayers']!;
      maxPlayers = mapPlayers['maxPlayers']!;
      divisions = mapPlayers['divisions']!;
    });
  }
  
  //FUNÇÃO PARA VALIDAR FORMULÁRIO
  bool validForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFIAR SE CAMPOS DE TEXTO FORAM PREENCHIDOS
    if(formData?.validate() ?? false){
      //VERIFICAR SE VISIBILIDADE FOI SELECIONADA
      if(eventController.visibilityController.text.isNotEmpty){
        return true;
      }
    }
    return false;
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (validForm()) {
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/event/register/address');
    }
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Registro", 
        leftAction: () => Get.back(),
        rightAction: () => navigationController.backHome(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 1
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Configuração de partidas",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Agora, Informe suas preferências para as partidas da pelada. Essas informações nos ajudará a melhora a sua experiência no app",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Categoria",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: categories.map((key){
                        //RESGATAR ICONE DA CATEGORIA
                        IconData icone = getIconCategory(key);
                        return SelectRoundedWidget(
                          value: key,
                          icon: icone,
                          size: 110,
                          iconSize: 40,
                          checked: eventController.categoryController.text == key,
                          onChanged: (value) {
                            //ATUALIZAR CATEGORIA
                            eventController.categoryController.text = key;
                            //DEFINIR QUANTIDADE DE EQUIPES POR TIME 
                            setPlayersPerTime(key);
                          }
                        );
                      }).toList()
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child:Text(
                          "Quantidade de Jogadores",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Defina quantos jogadores atuaram em campo por cada equipe. Essa informação poderá ser alterada a qualquer momento após o registro.",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SilderPlayersWidget(
                        qtdPlayers: qtdPlayers.toDouble(),
                        minPlayers: minPlayers.toDouble(),
                        maxPlayers: maxPlayers.toDouble(),
                        divisions: divisions,
                        onChange: (value){
                          setState(() {
                            //ATUALIZAR QUANTIDADE DE JOGADORES
                            qtdPlayers = value.clamp(minPlayers, maxPlayers).toInt();
                            eventController.playersPerTeamController.text = qtdPlayers.toString();
                          });
                        },
                      ),
                      /* CampoWidget(
                        categoria: eventController.categoryeventController.text,
                        qtd: eventController.qtdPlayers,
                      ), */
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: InputTextWidget(
                      name: 'duration',
                      label: bool.parse(eventController.hasTwoHalvesController.text)
                        ? "Duração (min. por tempo)" 
                        : "Duração (min.)",
                      prefixIcon: Icons.timer_outlined,
                      textController: eventController.durationController,
                      controller: eventController,
                      type: TextInputType.number,
                      onChanged: (value) => eventController.durationController.text = value,
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
                      value: bool.parse(eventController.hasTwoHalvesController.text),
                      onChanged: (value){
                        setState(() {
                          //ATUALIZAR VALOR DO SWITCH
                          eventController.hasTwoHalvesController.text = value.toString();
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
                      value: bool.parse(eventController.hasExtraTimeController.text),
                      onChanged: (value){
                        setState(() {
                          //ATUALIZAR ESTADO DE PRORROGAÇÃO
                          hasExtraTime = value;
                          //ATUALIZAR VALOR 
                          eventController.hasExtraTimeController.text = value.toString();
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
                      prefixIcon: Icons.more_time_rounded,
                      textController: eventController.extraTimeController,
                      controller: eventController,
                      type: TextInputType.number,
                      onChanged: (value) => eventController.extraTimeController.text = value,
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
                      value: bool.parse(eventController.hasPenaltyController.text),
                      onChanged: (value){
                        setState(() {
                          eventController.hasPenaltyController.text = value.toString();
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
                      value: bool.parse(eventController.hasGoalLimitController.text),
                      onChanged: (value){
                        setState(() {
                          hasGoalLimit = value;
                          eventController.hasGoalLimitController.text = value.toString();
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
                      textController: eventController.goalLimitController,
                      controller: eventController,
                      type: TextInputType.number,
                      onChanged: (value) => eventController.goalLimitController.text = value,
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
                      value: bool.parse(eventController.hasRefereerController.text),
                      onChanged: (value) {
                        setState(() {
                          hasRefereer = value;
                          eventController.hasRefereerController.text = value.toString();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ButtonOutlineWidget(
                        text: "Voltar",
                        width: 100,
                        action: () => Get.back(),
                      ),
                      ButtonTextWidget(
                        text: "Próximo",
                        width: 100,
                        action: submitForm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}