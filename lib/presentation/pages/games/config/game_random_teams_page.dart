import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/presentation/widget/indicators/indicator_loading_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/buttons/float_button_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_outline_widget.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_alert_team.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_random_team.dart';
import 'package:futzada/presentation/widget/bottomSheet/bottomsheet_game_players.dart';
import 'package:futzada/presentation/widget/cards/card_player_game_widget.dart';
import 'package:futzada/presentation/widget/cards/card_player_present_widget.dart';

class GameRandomTeamsPage extends StatefulWidget {
  const GameRandomTeamsPage({super.key});

  @override
  State<GameRandomTeamsPage> createState() => _GameRandomTeamsPageState();
}

class _GameRandomTeamsPageState extends State<GameRandomTeamsPage> {
  //CONTROLLER - PARTIDA
  GameController gameController = GameController.instance;
  //ESTADO - ITEMS EVENTO
  late Color eventColor;
  //LISTA DE PARTICIPANTES - TEMPORARIA
  List<UserModel> participantsPresentClone = [];
  //ESTADOS - EQUIPES
  RxBool teamDefined = false.obs;
  RxBool reorderList = false.obs;
  late int qtdPlayers;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //INICIALIZAR CONTROLLERS DE EQUIPES
    gameController.initTeamsControllers();
    //ESTADO - ITEMS EVENTO
    eventColor = ModalityHelper.getEventModalityColor(gameController.event.gameConfig?.category ?? gameController.event.modality!.name)['color'];
    //RESGATAR QUANTIDADE DE JOGADORES DEFINIDO
    qtdPlayers = gameController.currentGameConfig!.playersPerTeam!;
    //VERIFICAR SE CONFIGURAÇÕES E EQUIPES DA PARTIDA ESTÃO PRONTOS 
    WidgetsBinding.instance.addPostFrameCallback((_){
      //VERIFICAR SE QUATIDADE DE PARTICIPANTES JÁ E SUFICIENTE PARA FORMAR AS EQUIPES
      if(gameController.participantsPresent.length < qtdPlayers * 2){
        //EXIBIR DIALOG DE FALTA DE PARTICIPANTES
        Get.dialog(const DialogAlertTeam());
      }else{
        //VERIFICAR SE TIME JA ESTA DEFINIDO
        if(gameController.teamA.players.isNotEmpty && gameController.teamB.players.isNotEmpty){
          //ATUALIZAR VARIAVEL DE DEFINIÇÃO DE EQUIPE
          teamDefined.value = true;
        }
      }
    });
  }

  //FUNÇÃO PARA PROSSEGUIR OU RETROCEDER NAS CONFIGURAÇÕES
  void setTeams(){
    //VERIIFCAR SE EQUIPES FORAM MONTADAS
    if(
      gameController.teamA.players.length == gameController.currentGameConfig!.playersPerTeam && 
      gameController.teamA.players.length == gameController.currentGameConfig!.playersPerTeam
    ){
      //DEIFNIR EQUIEPES E DISPENSAR CONTROLLERS DE EQUIPES
      gameController.disposeTeamsControllers();
      gameController.isGameReady.value = true;
      //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
      Get.offNamed('/games/overview', arguments: {
        'game': gameController.currentGame,
        'event': gameController.event,
      });
    }else{
      AppHelper.feedbackMessage(context, "Os times não tem jogadores suficientes para continuar");
    }
  }

  //FUNÇÃO PARA REORDENAR LISTA DE PRESENTES
  void setOrderParticipants(String action){
    switch (action) {
      case "accept":
        //RESETAR LISTA PARA ESTADO INICIAL (AO CLICAR NO BOTÃO)
        participantsPresentClone = [];
        break;
      case "cancel":
        //RESETAR LISTA PARA ESTADO INICIAL (AO CLICAR NO BOTÃO)
        gameController.participantsPresent.value = participantsPresentClone.toList();
        break;
      case "reset":
        //RESETAR LISTA PARA ESTADO INICIAL (AO DEFINIR ENTRADA DE PARTICIPANTES)
        gameController.participantsPresent.value = gameController.participantsClone.toList();
        break;
    }
    participantsPresentClone = [];
    gameController.update();
    //ATUALIZAR ESTADO
    reorderList.value = !reorderList.value;
  }
  
  @override
  Widget build(BuildContext context) {
   //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: HeaderWidget(
        title: "Definição de Equipes",
        backgroundColor: eventColor,
        leftAction: () => Get.back(),
        rightIcon: AppIcones.cog_solid,
        rightAction: () {
          //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
          Get.toNamed('/games/config', arguments: {
            'game': gameController.currentGame,
          });
        },
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: eventColor,
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
                        "Defina as equipes que irão disputar a partida. A escolha dos jogadores das equipes pode ser feita por sorteio, ordem de chegada ou manualmente.",
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  spacing: 10,
                  children: [
                    /* Row(
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
                          image: const AssetImage(AppImages.cardFootball) as ImageProvider,
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
                                  AppColors.grey_300, 
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
                                  AppColors.grey_300, 
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), */
                    Text(
                      "Elencos",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(2, (i){
                        return Obx((){
                          //RESGATAR TAMANHO DAS EQUIPES (REATIVO)
                          final teamLength = i == 0 
                            ? gameController.teamAlength.value
                            : gameController.teamBlength.value;
                
                          //RESGATAR TAMANHO DAS EQUIPES (ESTATICO)
                          final teamCount = i == 0 
                            ? gameController.teamA.players.length
                            : gameController.teamB.players.length;
                          //RESGATAR NOME DAS EQUIPES
                          final teamName = i == 0 
                            ? gameController.teamANameController.text
                            : gameController.teamBNameController.text;
                
                          return Expanded(
                            child: Column(
                              spacing: 20,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: dimensions.width * 0.37,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          if (qtdPlayers == teamLength)...[
                                            BoxShadow(
                                              color: eventColor.withAlpha(70),
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
                                        backgroundColor: qtdPlayers == teamLength
                                          ? eventColor 
                                          : Theme.of(context).inputDecorationTheme.fillColor,
                                        textColor: qtdPlayers == teamLength
                                          ? AppColors.blue_500
                                          : Theme.of(context).textTheme.bodyLarge!.color,
                                        text: teamName,
                                        icon: AppIcones.users_solid,
                                        iconSize: 15,
                                        iconAfter: i == 0,
                                        action: () => Get.bottomSheet(
                                          BottomSheetGamePlayers(
                                            team: 0,
                                            qtdPlayers: qtdPlayers
                                          ),
                                          isScrollControlled: true
                                        ).whenComplete(() {
                                          setState(() => gameController.teamAlength.value = teamCount);
                                        }),
                                      )
                                    ),
                                    if(qtdPlayers > teamCount)...[
                                      Positioned(
                                        right: i == 0 ? 5 : null,
                                        left: i == 1 ? 5 : null,
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
                                Column(
                                  spacing: 2,
                                  children: List.generate(qtdPlayers, (item){
                                    //DEFINIR NOME, USER NAME, FOTO PADRÃO PARA OCUPANTE DO TIME
                                    String name = "Jogador";
                                    String userName = "jogador";
                                    dynamic photo;
                                    //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                                    if (item < teamLength) {
                                      //RESGATAR PARTICIPANT NA EQUIPE 
                                      final user = i == 0 
                                        ? gameController.teamA.players[item]
                                        : gameController.teamB.players[item];
                                      //RESGATAR NOME, USER NAME E FOTO DO PARTICIPANTE
                                      name = UserHelper.getFullName(user);
                                      userName = user.userName!;
                                      photo = user.photo;
                                    }
                          
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode ?AppColors.dark_300 : AppColors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          if(i == 0)...[
                                            ImgCircularWidget(
                                              width: 40, 
                                              height: 40,
                                              borderColor: AppColors.blue_300,
                                              image: photo,
                                            ),
                                          ],
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment: i == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: Theme.of(context).textTheme.titleSmall,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    "@$userName",
                                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                                      color: AppColors.grey_300
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if(i == 1)...[
                                            ImgCircularWidget(
                                              width: 40, 
                                              height: 40,
                                              borderColor: AppColors.red_300,
                                              image: photo,
                                            ),
                                          ],
                                        ]
                                      ),
                                    );
                                  })
                                )
                              ]
                            ),
                          );
                        });
                      }).toList()
                    ),
                    if(teamDefined.value)...[
                      ButtonTextWidget(
                        text: "Definir Equipes",
                        width: dimensions.width,
                        backgroundColor: eventColor,
                        height: 30,
                        action: () => setTeams()
                      ),
                      ButtonOutlineWidget(
                        text: "Resetar",
                        width: dimensions.width,
                        icon: Icons.restart_alt_rounded,
                        iconSize: 30,
                        action: () async{
                          await Get.showOverlay(
                            asyncFunction: (){
                              teamDefined.value = false;
                              return gameController.teamService.resetPlayersTeams();
                            },
                            loadingWidget: const Center(child: IndicatorLoadingWidget()),
                            opacity: 0.7,
                            opacityColor: AppColors.dark_700
                          );
                        }
                      ),
                    ],
                    const Divider(),
                    if(gameController.participantsPresent.isNotEmpty)...[
                      Obx((){
                        return Column(
                          spacing: 10,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Jogadores de proxima",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.start,
                                ), 
                                if(!reorderList.value)...[
                                  ButtonTextWidget(
                                    text: "Reordenar",
                                    icon: Icons.reorder_rounded,
                                    width: 100,
                                    height: 20,
                                    textColor: eventColor,
                                    backgroundColor: Colors.transparent,
                                    action: () => {
                                      participantsPresentClone = gameController.participantsPresent.toList(),
                                      reorderList.value = !reorderList.value
                                    },
                                  )
                                ]
                              ],
                            ),
                            if(reorderList.value)...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [ 
                                  ButtonTextWidget(
                                    text: "Cancelar",
                                    icon: Icons.close,
                                    width: 100,
                                    height: 20,
                                    textColor: AppColors.red_300,
                                    backgroundColor: Colors.transparent,
                                    action: () => setOrderParticipants("cancel"),
                                  ),
                                  ButtonTextWidget(
                                    text: "Resetar",
                                    icon: Icons.restart_alt_rounded,
                                    width: 100,
                                    height: 20,
                                    textColor: AppColors.grey_300,
                                    backgroundColor: Colors.transparent,
                                    action: () => setOrderParticipants("reset"),
                                  ),
                                  ButtonTextWidget(
                                    text: "Definir",
                                    icon: Icons.check,
                                    width: 100,
                                    height: 20,
                                    textColor: AppColors.green_300,
                                    backgroundColor: Colors.transparent,
                                    action: () => setOrderParticipants("accept"),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 110 *(gameController.event.gameConfig!.playersPerTeam! * 2),
                                child: ReorderableListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  onReorder: (oldIndex, newIndex) => gameController.reorderParticipants(oldIndex, newIndex),
                                  proxyDecorator: (child, index, animation) {
                                    return AnimatedBuilder(
                                      animation: animation,
                                      builder: (context, _) {
                                        final scale = Tween<double>(
                                          begin: 1,
                                          end: 1.03,
                                        ).animate(
                                          CurvedAnimation(parent: animation, curve: Curves.easeOut),
                                        );

                                        return Transform.scale(
                                          scale: scale.value,
                                          child: Material(
                                            elevation: 6,
                                            borderRadius: BorderRadius.circular(10),
                                            color: Theme.of(context).primaryColor.withAlpha(50),
                                            child: child,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  children: gameController.participantsPresent
                                    .where((p) => UserHelper.getParticipant(p.participants, gameController.event.id!)!.role!.contains("Player"))
                                    .take(gameController.event.gameConfig!.playersPerTeam! * 2)
                                    .map((user){
                                      return Row(
                                        spacing: 10,
                                        key: ValueKey(user.id),
                                        children: [
                                          const Icon(
                                            Icons.drag_indicator_rounded,
                                            color: AppColors.grey_300,
                                          ),
                                          Expanded(
                                            child: CardPlayerPresentWidget(
                                              user: user,
                                              modality: gameController.event.modality!.name,
                                              present: gameController.participantsPresent.contains(user),
                                            ),
                                          ),
                                        ],
                                      );
                                  }).toList(),
                                ),
                              ),
                            ]else...[
                              Column(
                                spacing: 5,
                                children: gameController.participantsPresent
                                  .take(gameController.event.gameConfig!.playersPerTeam! * 2)
                                  .map((user){
                                    return CardPlayerPresentWidget(
                                      key: ValueKey(user.id),
                                      user: user,
                                      modality: gameController.event.modality!.name,
                                      present: gameController.participantsPresent.contains(user),
                                    );
                                }).toList(),
                              ),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Mais jogadores presentes",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                ButtonTextWidget(
                                  text: "Ver Mais",
                                  icon: Icons.add_rounded,
                                  width: 100,
                                  height: 20,
                                  textColor: eventColor,
                                  backgroundColor: Colors.transparent,
                                  action: () {},
                                ) 
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: gameController.participantsPresent
                                  .skip(gameController.event.gameConfig!.playersPerTeam! * 2)
                                  .take(gameController.event.gameConfig!.playersPerTeam!)
                                  .map((user){
                                    return CardPlayerGameWidget(
                                      key: ValueKey(user.id),
                                      user: user,
                                    );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      })
                    ],
                  ],
                )
              ),
            ]
          ),
        )
      ),
      floatingActionButton: Obx((){
        if(!teamDefined.value && gameController.participantsPresent.length >= gameController.currentGameConfig!.playersPerTeam! * 2){
          return FloatButtonWidget(
            floatKey: "escalation_game",
            icon: Icons.content_paste_go_rounded,
            backgroundColor: eventColor,
            onPressed: () => Get.dialog(
              DialogRandomTeam(
                actionRandom: () async {
                  await gameController.teamService.setPlayersTeams(true);
                  setState(() {
                    teamDefined.value = true;
                  });
                },
                actionOrder: () async {
                  await gameController.teamService.setPlayersTeams(false);
                  setState(() {
                    teamDefined.value = true;
                  });
                }
              ),
            ), 
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}