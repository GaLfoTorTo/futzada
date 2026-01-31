import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/core/helpers/event_helper.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/widget/buttons/button_vote_widget.dart';
import 'package:futzada/presentation/widget/cards/card_player_game_widget.dart';

class GameOverviewPage extends StatefulWidget {
  const GameOverviewPage({super.key});

  @override
  State<GameOverviewPage> createState() => _GameOverviewPageState();
}

class _GameOverviewPageState extends State<GameOverviewPage> {
  //RESGATAR CONTROLLER DE PARTIDAS
  GameController gameController = GameController.instance;
  //ITEMS DO EVENTO
  late Color eventColor;
  //ITEMS DE PARTIDA
  late GameModel game;
  late TeamModel teamA;
  late TeamModel teamB;
  late double team1Value;
  late double team2Value;

  @override
  void initState(){
    super.initState();
    eventColor = ModalityHelper.getEventModalityColor(gameController.event.gameConfig?.category ?? gameController.event.modality!.name)['color'];
    //PARTIDA ATUAL
    game = gameController.currentGame;
    //RESGATAR EQUIPES
    teamA = gameController.currentGame.teams!.first;
    teamB = gameController.currentGame.teams!.last;
    //RESGATAR VALORES DE VOTAÇÃO
    team1Value = gameController.votesGame['team1'] ?? 0.0;
    team2Value = gameController.votesGame['team2'] ?? 0.0;
  }

  //FUNÇÃO DE COLETA DE CHAVES
  String getOption(String key) {
    if (key == 'team1') {
      return team1Value > team2Value ? "Win" : "Lose";
    }
    if (key == 'team2') {
      return team2Value > team1Value ? "Win" : "Lose";
    }
    return "Draw";
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE INFORMAÇÕES SOBRE AS PARTIDAS
    List<Map<String, dynamic>> infoGame = EventHelper.getDetailGame(gameController.event);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: dimensions.width,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              color: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark_500.withAlpha(30),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: const Offset(2, 5),
                ),
              ],
            ),
            child: Obx((){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Text(
                    "Detalhes da Partida",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      //CONTAINER BASE DE DIMENSIONAMENTO
                      SizedBox(
                        width: dimensions.width,
                        height: 150,
                      ), 
                      Positioned(
                        bottom: -100,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateZ(pi / 2)
                            ..rotateY(0.9),
                          child: Container(
                            width: 200,
                            height: 350,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.white, width: 5),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.dark_300.withAlpha(50),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(5, 0),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              ModalityHelper.getCategoryCourt(gameController.event.gameConfig!.category),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  SizedBox(
                    width: dimensions.width,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        ...infoGame.map((item){
                          return SizedBox(
                            width: dimensions.width * 0.4,
                            child: Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: eventColor.withAlpha(50),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Icon(
                                        item['icon'],
                                        size: 30,
                                        color: eventColor,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            item['label'],
                                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                              color: AppColors.grey_500
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Text(
                                          item['value'],
                                          style: Theme.of(context).textTheme.titleSmall,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),      
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  if(gameController.currentGameConfig?.config!["hasRefereer"] ?? false)...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              backgroundImage: ImgHelper.getUserImg(
                                EventHelper.getUserEvent(gameController.event, gameController.currentGame.refereeId!)?.photo 
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    "Arbítro",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: AppColors.grey_500
                                    ),
                                  ),
                                  Icon(
                                    Icons.sports,
                                    size: 20,
                                    color: eventColor,
                                  ),
                                ],
                              ),
                              Text(
                                UserHelper.getFullName(EventHelper.getUserEvent(gameController.event, gameController.currentGame.refereeId!)!),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quem Vencerá a Partida ?",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "Total de Votos: ${gameController.votesGameCount}",
                        style: Theme.of(context).textTheme.labelSmall
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: gameController.votesGame.entries.map((item){
                      //RESGATAR VALOR DE VOTAÇÃO
                      final String option = getOption(item.key);
                      final double value = item.value;
                      //RESGATAR NOME DAS EQUIPES
                      final String team = item.key == 'team1'
                          ? teamA.name!
                          : item.key == 'team2'
                              ? teamB.name!
                              : "Empate";
                      //RESGATAR STATUS DE VOTAÇÃO
                      final String status = option == "Win"
                          ? "Vitória"
                          : option == "Lose"
                              ? "Derrota"
                              : "Empate";
                      //RESGATAR COR DE STATUS DE VOTAÇÃO
                      final Color statusColor = option == "Win"
                          ? eventColor
                          : option == "Lose"
                              ? AppColors.red_300
                              : AppColors.grey_300;
                      return Column(
                        spacing: 10,
                        children: [
                          Text(
                            team,
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: statusColor
                            ),
                          ),
                          ButtonVoteWidget(
                            option: option,
                            value: value,
                            action: (){},
                          ),
                          Text(
                            "$status ${value.toStringAsFixed(0)}%",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: statusColor
                            ),
                          )
                        ],
                      );
                    }).toList()
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quem será o MVP ?",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "Total de Votos: ${gameController.votesMVPCount}",
                        style: Theme.of(context).textTheme.labelSmall
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: gameController.votesMVP.entries.take(3).map((item){
                        //RESGATAR PARTICIPANTE
                        UserModel user = teamA.players.firstWhere((u) => u.uuid == item.key);
                        //RESGATAR VALOR DE VOTAÇÃO
                        int value = item.value;
                        
                        return Column(
                        spacing: 10,
                          children: [
                            CardPlayerGameWidget(user: user),
                            Text(
                              "${value.toStringAsFixed(0)} votos",
                              style: Theme.of(context).textTheme.labelMedium
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ]
              );
            })
          )
        ]
      )
    );
  }
}