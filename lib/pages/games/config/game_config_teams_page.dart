import 'dart:math';
import 'package:futzada/widget/cards/card_player_game_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/services/game_service.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/widget/bottomSheet/bottomsheet_emblemas.dart';
import 'package:futzada/widget/bottomSheet/bottomsheet_game_players.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/dialogs/dialog_random_team.dart';
import 'package:futzada/widget/inputs/silder_players_widget.dart';

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
  
  //DEFINIR VARIAVEIS DE CONTROLLE DE SLIDER
  late int qtdPlayers;
  late int minPlayers;
  late int maxPlayers;
  late int divisions;
  //DEFINIR CONTROLADOR DE PARTICIPANTS DA PELADA
  List<ParticipantModel>? participants = [];
  //CONTROLADOR DE VISUALIZAÇÃO DE EQUIPE
  RxBool teamDefined = false.obs;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //INICIALIZAR VALORES DE SLIDER
    qtdPlayers = gameController.currentGameConfig!.playersPerTeam!;
    minPlayers = gameService.getQtdPlayers(gameController.categoryController.text)['minPlayers']!;
    maxPlayers = gameService.getQtdPlayers(gameController.categoryController.text)['maxPlayers']!;
    divisions = gameService.getQtdPlayers(gameController.categoryController.text)['divisions']!;
    //VERIFICAR SE TIME JA ESTA DEFINIDO
    if(gameController.teamA.players.isNotEmpty && gameController.teamB.players.isNotEmpty){
      //ATUALIZAR VARIAVEL DE DEFINIÇÃO DE EQUIPE
      teamDefined.value = true;
    }
  }

  //FUNÇÃO DE DEFINIÇÃO DE METODO DE ESCOLHA DE EQUIPES
  Future<bool> setRandomTeams(bool action) async{
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE FUNÇÃO DEVE SORTEAR AUTOMATICAMENTE OS JOGADORES DA EQUIPE
    if(action){
      //RESGATAR PARTICIPANTES DO EVENTO
      final participants = gameController.event.participants!.take(qtdPlayers * 2);
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
    teamDefined.value = true;
    setState(() {});
    //FINALIZAR FUNÇÃO
    return true;
  }

  //FUNÇÃO PARA DEFINIR LIMITE DE JOGADORES POR EQUIPE
  void setPlayersPerTime(double newValue){
    setState(() {
      //DEFINIR LIMITE DE JOGADORES POR TIME
      qtdPlayers = newValue.toInt();
      gameController.currentGameConfig!.playersPerTeam = qtdPlayers;
      //ATUALIZAR OBSERVADOR DE TAMANHO DE EQUIPES
      gameController.teamAlength.value = qtdPlayers;
      gameController.teamBlength.value = qtdPlayers;
      //VERIFICAR SE TIMES FORAM DEFINIDOS
      if(teamDefined.value){
        //VERIFICAR QUANTOS JOGADORES ESTÃO DEFINIDOS EM CADA TIME
        if(gameController.teamA.players.length > qtdPlayers || gameController.teamB.players.length > qtdPlayers){
          //REMOVER JOGADORES EXCEDENTES DO TIME A
          while (gameController.teamA.players.length > qtdPlayers) {
            gameController.teamA.players.removeLast();
          }
          //REMOVER JOGADORES EXCEDENTES DO TIME B
          while (gameController.teamB.players.length > qtdPlayers) {
            gameController.teamB.players.removeLast();
          }
        }
      }
    });
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
            Text(
              'Definição de Equipes',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AppColors.green_300
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
                        label: 'Time 1',
                        textController: gameController.teamANameController,
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
                        label: 'Time 2',
                        textController: gameController.teamBNameController,
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
                      BottomSheetEmblema(
                        emblema: gameController.teamAEmblemaController.text,
                        team: true,
                      ), 
                      isScrollControlled: true
                    ).whenComplete(() => setState(() {})),
                    child: Container(
                      width: dimensions.width * 0.37,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Get.isDarkMode ?AppColors.dark_300 : AppColors.white,
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
                        AppIcones.emblemas[gameController.teamAEmblemaController.text]!,
                        width: 100,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray_300, 
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(
                      "VS",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: AppColors.blue_500
                      ),
                    )
                  ),
                  InkWell(
                    onTap: () => Get.bottomSheet(
                      BottomSheetEmblema(
                        emblema: gameController.teamBEmblemaController.text,
                        team: false,
                      ), 
                      isScrollControlled: true
                    ).whenComplete(() => setState(() {})),
                    child: Container(
                      width: dimensions.width * 0.37,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Get.isDarkMode ?AppColors.dark_300 : AppColors.white,
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
                        AppIcones.emblemas[gameController.teamBEmblemaController.text]!,
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
            if(gameController.participantsPresent.isNotEmpty)...[
              Text(
                "Lista de Participantes",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 210,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 15,
                    children: gameController.event.participants!.take(5).map((item){
                      //RESGATAR PARTICIPANT
                      ParticipantModel participant = item;
                      return CardPlayerGameWidget(participant: participant);
                    }).toList(),
                  )
                )
              )
            ],
            SilderPlayersWidget(
              onChange: (value) => setPlayersPerTime(value),
              qtdPlayers: qtdPlayers.toDouble(),
              minPlayers: minPlayers.toDouble(),
              maxPlayers: maxPlayers.toDouble(),
              divisions: divisions,
            ),
            ButtonTextWidget(
              width: dimensions.width,
              height: 30,
              backgroundColor:AppColors.green_300,
              text: "Definir Equipes",
              textSize: 15,
              textColor: AppColors.blue_500,
              action: () => Get.dialog(
                DialogRandomTeam(
                  actionRandom: () => setRandomTeams(true),
                  actionSet: () => setRandomTeams(false),
                ),
              )
            ),
            if(teamDefined.value)...[
              Text(
                "Elencos",
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
                                if (qtdPlayers == gameController.teamAlength.value && qtdPlayers == gameController.teamA.players.length)...[
                                  BoxShadow(
                                    color: AppColors.green_300.withAlpha(70),
                                    spreadRadius: 5,
                                    blurRadius: 1,
                                    offset: const Offset(0,0),
                                  ),
                                ]
                              ],
                            ),
                            child: ButtonTextWidget(
                              width: dimensions.width,
                              height: 30,
                              backgroundColor: gameController.teamA.players.length == qtdPlayers 
                                ? AppColors.green_300 
                                : Theme.of(context).inputDecorationTheme.fillColor,
                              textColor: Theme.of(context).textTheme.bodyLarge!.color,
                              text: gameController.teamANameController.text,
                              icon: AppIcones.users_solid,
                              iconSize: 15,
                              action: () => Get.bottomSheet(
                                BottomSheetGamePlayers(
                                  team: 0,
                                  qtdPlayers: qtdPlayers
                                ),
                                isScrollControlled: true
                              ).whenComplete(() {
                                setState(() {
                                  //ATUALIZAR QTD DE JOGADORES POR EQUIE
                                  gameController.teamAlength.value = gameController.teamA.players.length;
                                  gameController.teamBlength.value = gameController.teamB.players.length;
                                });
                              }),
                            )
                          ),
                          if(gameController.teamA.players.length < qtdPlayers)...[
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
                                if (qtdPlayers == gameController.teamAlength.value &&
                                    qtdPlayers == gameController.teamA.players.length)...[
                                  BoxShadow(
                                    color: AppColors.green_300.withAlpha(70),
                                    spreadRadius: 5,
                                    blurRadius: 1,
                                    offset: const Offset(0,0),
                                  ),
                                ]
                              ],
                            ),
                            child: ButtonTextWidget(
                              width: dimensions.width,
                              height: 30,
                              backgroundColor: gameController.teamA.players.length == qtdPlayers 
                                ? AppColors.green_300 
                                : Theme.of(context).inputDecorationTheme.fillColor,
                              textColor: Theme.of(context).textTheme.bodyLarge!.color,
                              text: gameController.teamBNameController.text,
                              textSize: 15,
                              icon: AppIcones.users_solid,
                              iconSize: 15,
                              action: () => Get.bottomSheet(
                                BottomSheetGamePlayers(
                                  team: 1,
                                  qtdPlayers: qtdPlayers
                                ),
                                isScrollControlled: true
                              ).whenComplete(() {
                                setState(() {
                                  //ATUALIZAR QTD DE JOGADORES POR EQUIE
                                  gameController.teamAlength.value = gameController.teamA.players.length;
                                  gameController.teamBlength.value = gameController.teamB.players.length;
                                });
                              }),
                            )
                          ),
                          if(gameController.teamB.players.length < qtdPlayers)...[
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
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  spacing: 2,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx((){
                      return Column(
                        children: List.generate(qtdPlayers, (item){
                          //DEFINIR NOME, USER NAME, FOTO PADRÃO PARA OCUPANTE DO TIME
                          String name = "Jogador";
                          String userName = "jogador";
                          dynamic photo;
                          //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                          if (item < gameController.teamAlength.value &&
                              item < gameController.teamA.players.length) {
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
                              color: Get.isDarkMode ?AppColors.dark_300 : AppColors.white,
                              border: const Border(
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
                          //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                          if (item < gameController.teamBlength.value &&
                              item < gameController.teamB.players.length) {
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
                              color: Get.isDarkMode ?AppColors.dark_300 : AppColors.white,
                              border: const Border(
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