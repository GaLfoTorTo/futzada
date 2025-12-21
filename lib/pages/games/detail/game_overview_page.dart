import 'dart:math';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/services/escalation_service.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/widget/buttons/button_vote_widget.dart';
import 'package:futzada/widget/cards/card_player_game_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GameOverviewPage extends StatefulWidget {
  const GameOverviewPage({super.key});

  @override
  State<GameOverviewPage> createState() => _GameOverviewPageState();
}

class _GameOverviewPageState extends State<GameOverviewPage> {
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE PARTIDAS
    GameController gameController = GameController.instance;
    //DEFINIR SERVIÇO DE CAMPO/QUADRA
    EscalationService escalationService = EscalationService();
    //PARTIDA ATUAL
    final game = gameController.currentGame;
    //RESGATAR EQUIPES
    final teamA = gameController.currentGame.teams!.first;
    final teamB = gameController.currentGame.teams!.last;
    //RESGATAR VALORES DE VOTAÇÃO
    final team1Value = gameController.votesGame['team1'] ?? 0.0;
    final team2Value = gameController.votesGame['team2'] ?? 0.0;

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
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: dimensions.width,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark_500.withAlpha(30),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset(2, 5),
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
                        bottom: -80,
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
                                  offset: Offset(5, 0),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              escalationService.fieldType(gameController.event.gameConfig!.category),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
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
                                  color: AppColors.green_300.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 30,
                                  color: AppColors.green_300,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Previsão de Início/Fim",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: AppColors.gray_500
                                    ),
                                  ),
                                  Text(
                                    "${DateFormat("HH:ss").format(game.startTime!)} - ${DateFormat("HH:ss").format(game.endTime!)}",
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),      
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.green_300.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Icon(
                                  Icons.timer_rounded,
                                  size: 30,
                                  color: AppColors.green_300,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Duração de Partida",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: AppColors.gray_500
                                    ),
                                  ),
                                  Text(
                                    "${gameController.currentGameConfig?.duration} minutos",
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),      
                            ],
                          )
                        ],
                      ),
                      Column(
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
                                  color: AppColors.green_300.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Icon(
                                  Icons.scoreboard_rounded,
                                  size: 30,
                                  color: AppColors.green_300,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Limite de Gols",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: AppColors.gray_500
                                    ),
                                  ),
                                  Text(
                                    "${gameController.currentGameConfig!.goalLimit! > 0 ? gameController.currentGameConfig?.goalLimit : 'Nenhum'}",
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),      
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.green_300.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Icon(
                                  Icons.people,
                                  size: 30,
                                  color: AppColors.green_300,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Nº Jogadores",
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: AppColors.gray_500
                                    ),
                                  ),
                                  Text(
                                    "${gameController.currentGameConfig?.playersPerTeam}",
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),      
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  if(gameController.currentGameConfig?.hasRefereer ?? false)...[
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
                              backgroundImage: gameController.currentGame.referee?.user.photo != null
                                ? CachedNetworkImageProvider(gameController.currentGame.referee!.user.photo!) 
                                : const AssetImage(AppImages.userDefault) as ImageProvider,
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
                                      color: AppColors.gray_500
                                    ),
                                  ),
                                  const Icon(
                                    Icons.sports,
                                    size: 20,
                                    color: AppColors.green_300,
                                  ),
                                ],
                              ),
                              Text(
                                "${gameController.currentGame.referee?.user.firstName} ${gameController.currentGame.referee?.user.lastName}",
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
                          ? AppColors.green_300
                          : option == "Lose"
                              ? AppColors.red_300
                              : AppColors.gray_300;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: gameController.votesMVP.entries.take(3).map((item){
                      //RESGATAR PARTICIPANTE
                      ParticipantModel participant = teamA.players.firstWhere((p) => p.user.uuid == item.key);
                      //RESGATAR VALOR DE VOTAÇÃO
                      int value = item.value;
                      
                      return Column(
                      spacing: 10,
                        children: [
                          CardPlayerGameWidget(participant: participant),
                          Text(
                            "${value.toStringAsFixed(0)} votos",
                            style: Theme.of(context).textTheme.labelMedium
                          )
                        ],
                      );
                    }).toList(),
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