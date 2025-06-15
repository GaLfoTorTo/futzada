import 'dart:math';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
import 'package:futzada/widget/dialogs/random_team_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/services/game_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/widget/dialogs/emblemas_dialog.dart';
import 'package:futzada/widget/dialogs/game_players_dialog.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';

class GameConfigTeamsPage extends StatefulWidget {
  const GameConfigTeamsPage({super.key});

  @override
  State<GameConfigTeamsPage> createState() => _GameConfigTeamsPageState();
}

class _GameConfigTeamsPageState extends State<GameConfigTeamsPage> {
  //RESHATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //DEFINIR SERVIÇO DE EVENTO
  GameService gameService = GameService();
  //DEFINIR EVENTO DA PARTIDA
  late EventModel event;
  //DEFINIR PARTIDA ATUAL
  late GameModel game;
  //DEFINIR CONFIGURAÇÕES DE PARTIDA DO EVENTO
  late GameConfigModel gameConfig;
  //DEFINIR CONTROLADORES DE TEXTO 
  late TextEditingController teamAController;
  late TextEditingController teamBController;
  late TextEditingController qtdPlayersController;
  //DEFINIR VARIAVEIS DE CONTROLLE DE SLIDER
  late int qtdPlayers;
  late int minPlayers;
  late int maxPlayers;
  late int divisions;
  //DEFINIR CONTROLADOR DE PARTICIPANTS DA PELADA
  List<ParticipantModel>? participants = [];
  //GERAR NUMERO ALEATORIO PARA INDEX DE EMBLEMAS
  int indexA = Random().nextInt(8);
  int indexB = Random().nextInt(8);
  //GERAR INDEX ALEATORIO PARA EMBLEMA DE EQUIPES
  late String emblemaIndexA;
  late String emblemaIndexB;
  //CONTROLADOR DE VISUALIZAÇÃO DE EQUIPE
  String viewType = 'escalation';
  bool teamDefined = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //RESGATAR EVENTO 
    event = gameController.event!;
    //RESGATAR CONFIGURAÇÕES DE PARTIDA DO EVENTO
    gameConfig = gameController.event!.gameConfig!;
    //RESGATAR PARTIDA ATUAL
    game = gameController.currentGame!;
    //RESGATAR PARTICIPANTES JOGADORES DO EVENTO
    participants = event.participants;
    //INICIALIZAR CAMPOS DE TEXTO
    teamAController = TextEditingController(text: "Team A");
    teamBController = TextEditingController(text: "Team B");
    qtdPlayersController = TextEditingController(text: gameConfig.playersPerTeam.toString());
    //INICIALIZAR VALORES DE SLIDER
    qtdPlayers = event.gameConfig!.playersPerTeam!;
    minPlayers = gameService.getQtdPlayers(gameConfig.category!)['minPlayers']!;
    maxPlayers = gameService.getQtdPlayers(gameConfig.category!)['maxPlayers']!;
    divisions = gameService.getQtdPlayers(gameConfig.category!)['divisions']!;
    //INICIALIZAR EMBLEMAS PADRÃO
    emblemaIndexA = "emblema_${indexA == 0 ? 1 : indexA}";
    emblemaIndexB = "emblema_${indexB == 0 ? 1 : indexB}";
  }

  //FUNÇÃO PARA SELECIONAR TIPO DE VISUALIZAÇÃO
  void selectView(type){
    setState(() {
      //VERIFICAR O TIPO RECEBIDO
      viewType = type;
    });
  }

  //FUNÇÃO DE DEFINIÇÃO DE METODO DE ESCOLHA DE EQUIPES
  Future<bool> setRandomTeams(bool action) async{
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE FUNÇÃO DEVE SORTEAR AUTOMATICAMENTE OS JOGADORES DA EQUIPE
    if(action){
      //RESGATAR PARTICIPANTES DO EVENTO
      final participants = gameController.event!.participants!.take(qtdPlayers * 2);
      //EMBARALHAR LISTA
      final shuffled = [...participants]..shuffle(Random());
      //LIMPAR JOGADORES SELECIONADOS DAS EQUIPES
      gameController.teamA.players.clear();
      gameController.teamB.players.clear();
      //ADICIONAR JOGADORES AS EQUIPES
      gameController.teamA.players.addAll(shuffled.take(qtdPlayers));
      gameController.teamB.players.addAll(shuffled.skip(qtdPlayers).take(qtdPlayers));
      //ATUALIZAR QTD DE JOGADORES POR EQUIE
      gameController.teamAlength.value = gameController.teamA.players.length;
      gameController.teamBlength.value = gameController.teamB.players.length;
    }
    //ATUALIZAR FLAG DE EXIBIÇÃO
    setState(() {
      teamDefined = true;
    });
    //FINALIZAR FUNÇÃO
    return true;
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
                'Definição de Equipes',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.green_300
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: dimensions.width * 0.37,
                  child: Column(
                    children: [
                      InputTextWidget(
                        name: 'teamAName',
                        label: 'Time A',
                        textController: teamAController,
                        controller: gameController,
                      ),
                    ],
                  )
                ),
                SizedBox(
                  width: dimensions.width * 0.37,
                  child: Column(
                    children: [
                      InputTextWidget(
                        name: 'teamBName',
                        label: 'Time B',
                        textController: teamBController,
                        controller: gameController,
                      ),
                    ],
                  )
                ),
              ],
            ),
            Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: const AssetImage(AppImages.gramado) as ImageProvider,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.green_300.withAlpha(150), 
                    BlendMode.srcATop,
                  )
                ),
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.bottomSheet(
                      EmblemasDialog(
                        emblema: emblemaIndexA
                      ), 
                      isScrollControlled: true
                    ),
                    child: Container(
                      width: dimensions.width * 0.37,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dark_500.withAlpha(30),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        AppIcones.emblemas[emblemaIndexA]!,
                        width: 100,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray_300, 
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.dark_500,
                      size: 50,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.bottomSheet(
                      EmblemasDialog(
                        emblema: emblemaIndexA
                      ), 
                      isScrollControlled: true
                    ),
                    child: Container(
                      width: dimensions.width * 0.37,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.dark_500.withAlpha(30),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(2, 5),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        AppIcones.emblemas[emblemaIndexB]!,
                        width: 100,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray_300, 
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 20),
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
                        qtdPlayers = newValue.toInt();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "$qtdPlayers",
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(qtdPlayers, (i){
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        child: ImgCircularWidget(
                          width: 30, 
                          height: 30
                        ),
                      );
                    }).toList()
                  )
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Elencos",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ButtonTextWidget(
              width: dimensions.width,
              height: 30,
              backgroundColor:AppColors.green_300,
              text: "Definir Equipes",
              textSize: 15,
              textColor: AppColors.blue_500,
              action: () => Get.dialog(
                RandomTeamDialog(
                  actionRandom: () => setRandomTeams(true),
                  actionSet: () => setRandomTeams(false),
                ),
              )
            ),
            if(teamDefined)...[
              Obx((){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: dimensions.width * 0.37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                if (gameController.teamAlength.value == qtdPlayers)
                                  BoxShadow(
                                    color: AppColors.green_300.withAlpha(70),
                                    spreadRadius: 5,
                                    blurRadius: 1,
                                    offset: const Offset(0,0),
                                  ),
                              ],
                            ),
                            child: ButtonTextWidget(
                              width: dimensions.width,
                              height: 30,
                              backgroundColor: gameController.teamAlength.value == qtdPlayers ? AppColors.green_300 : AppColors.white,
                              text: teamAController.text,
                              textSize: 15,
                              icon: AppIcones.users_solid,
                              textColor: AppColors.blue_500,
                              iconSize: 15,
                              action: () => Get.bottomSheet(
                                GamePlayersDialog(
                                  team: 0,
                                  qtdPlayers: qtdPlayers
                                ),
                                isScrollControlled: true
                              )
                            )
                          ),
                          if(gameController.teamAlength.value < qtdPlayers)...[
                            Positioned(
                              right: 5,
                              bottom: 0,
                              child: Container(
                                width: 25,
                                height: 25,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppColors.yellow_500,
                                ),
                                child: const Icon(
                                  AppIcones.exclamation_solid,
                                  color: AppColors.dark_700,
                                  size: 15,
                                ),
                              ),
                            )
                          ]
                        ]
                      ),
                      Stack(
                        children: [
                          Container(
                            width: dimensions.width * 0.37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                if (gameController.teamBlength.value == qtdPlayers)
                                  BoxShadow(
                                    color: AppColors.green_300.withAlpha(70),
                                    spreadRadius: 5,
                                    blurRadius: 1,
                                    offset: const Offset(0,0),
                                  ),
                              ],
                            ),
                            child: ButtonTextWidget(
                              width: dimensions.width,
                              height: 30,
                              backgroundColor: gameController.teamBlength.value == qtdPlayers ? AppColors.green_300 : AppColors.white,
                              text: teamBController.text,
                              textSize: 15,
                              icon: AppIcones.users_solid,
                              textColor: AppColors.blue_500,
                              iconSize: 15,
                              action: () => Get.bottomSheet(
                                GamePlayersDialog(
                                  team: 1,
                                  qtdPlayers: qtdPlayers
                                ),
                                isScrollControlled: true
                              ).whenComplete(() {
                                //ATUALIZAR QTD DE JOGADORES POR EQUIE
                                gameController.teamAlength.value = gameController.teamA.players.length;
                                gameController.teamBlength.value = gameController.teamB.players.length;
                              }),
                            )
                          ),
                          if(gameController.teamBlength.value < qtdPlayers)...[
                            Positioned(
                              left: 5,
                              bottom: 0,
                              child: Container(
                                width: 25,
                                height: 25,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppColors.yellow_500,
                                ),
                                child: const Icon(
                                  AppIcones.exclamation_solid,
                                  color: AppColors.dark_700,
                                  size: 15,
                                ),
                              ),
                            )
                          ]
                        ]
                      ),
                    ],
                  ),
                );
              }),
              Container(
                width: dimensions.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [ 
                    BoxShadow(
                      color: AppColors.dark_500.withAlpha(30),
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      offset: const Offset(2, 5),
                    ),
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx((){
                      return Column(
                        children: List.generate(qtdPlayers, (item){
                          //DEFINIR NOME, USER NAME, FOTO PADRÃO PARA OCUPANTE DO TIME
                          String name = "Jogador";
                          String userName = "jogador";
                          dynamic photo;
                          //RESGATAR QUANTIDADE DE INTEGRANETES DA EQUIPE
                          int teamAlength = gameController.teamAlength.value;
                          //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                          if(teamAlength > item){
                            //RESGATAR PARTICIPANT NA EQUIPE 
                            final participant = gameController.teamA.players[item];
                            //RESGATAR NOME, USER NAME E FOTO DO PARTICIPANTE
                            name = "${participant.user.firstName} ${participant.user.lastName}";
                            userName = participant.user.userName!;
                            photo = participant.user.photo;
                          }

                          return Container(
                            width: dimensions.width * 0.45,
                            decoration: BoxDecoration(
                              color: name == 'Jogador' ? AppColors.gray_300.withAlpha(50) : AppColors.white,
                              border: Border(
                                bottom: BorderSide(width: 1, color: AppColors.gray_300)
                              )
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ImgCircularWidget(
                                  width: 40, 
                                  height: 40,
                                  borderColor: AppColors.blue_300,
                                  image: photo,
                                ),
                                Container(
                                  width: dimensions.width * 0.3,
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "@$userName",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: AppColors.gray_300
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          );
                        })
                      );
                    }),
                    Obx((){
                      return Column(
                        children: List.generate(qtdPlayers, (item){
                          //DEFINIR NOME, USER NAME, FOTO PADRÃO PARA OCUPANTE DO TIME
                          String name = "Jogador";
                          String userName = "jogador";
                          dynamic photo;
                          //RESGATAR QUANTIDADE DE INTEGRANETES DA EQUIPE
                          int teamBlength = gameController.teamBlength.value;
                          //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                          if(teamBlength > item){
                            //RESGATAR PARTICIPANT NA EQUIPE 
                            final participant = gameController.teamB.players[item];
                            //RESGATAR NOME, USER NAME E FOTO DO PARTICIPANTE
                            name = "${participant.user.firstName} ${participant.user.lastName}";
                            userName = participant.user.userName!;
                            photo = participant.user.photo;
                          }

                          return Container(
                            width: dimensions.width * 0.45,
                            decoration: BoxDecoration(
                              color: name == 'Jogador' ? AppColors.gray_300.withAlpha(50) : AppColors.white,
                              border: Border(
                                bottom: BorderSide(width: 1, color: AppColors.gray_300)
                              )
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: dimensions.width * 0.3,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        name,
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "@$userName",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: AppColors.gray_300
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                ImgCircularWidget(
                                  width: 40, 
                                  height: 40,
                                  borderColor: AppColors.red_300,
                                  image: photo,
                                ),
                              ]
                            ),
                          );
                        })
                      );
                    }),
                  ],
                )
              ),
            ]
          ]
        ),
    );
  }
}