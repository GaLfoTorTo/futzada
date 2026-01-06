import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/utils/img_utils.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/player_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/badges/position_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/cards/card_day_game_widget.dart';
import 'package:futzada/widget/cards/card_game_live_widget.dart';
import 'package:futzada/widget/cards/card_game_widget.dart';
import 'package:futzada/widget/cards/card_mvp_widget.dart';
import 'package:futzada/widget/cards/card_player_game_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_page_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class GamesDayPage extends StatelessWidget {
  const GamesDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENTO
    EventModel event = Get.arguments['event'];
    //RESGATAR CONTROLLER DE PARTIDAS
    GameController gameController = GameController.instance;
    //CONTROLLADOR DE BARRA DE ROLAGEM
    PageController nextGamesController = PageController();
    //JOGADORES DESTAQUE
    final highlightsPlayers = event.participants!.take(3);
    
    return Scaffold(
      appBar: HeaderWidget(
        title: 'Dia de Jogo',
        leftAction: () => Get.back(),
        rightIcon: Icons.history,
        rightAction: () => Get.toNamed('/games/historic'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImgCircularWidget(
                      width: 30, 
                      height: 30,
                      image: event.photo,
                      element: "event",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${event.title}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                if(gameController.inProgressGames.isNotEmpty)...[
                  Obx((){
                    var game = gameController.inProgressGames.first;
                    return CardGameLiveWidget(
                      event: event,
                      game: game!,
                    );
                  }),
                ]else...[
                  CardDayGameWidget(event: event),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Próximas partidas',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    ButtonTextWidget(
                      text: "Ver Mais",
                      icon: LineAwesomeIcons.plus_solid,
                      width: 100,
                      height: 20,
                      textColor: AppColors.green_300,
                      backgroundColor: Colors.transparent,
                      action: () {},
                    )
                  ],
                ),
                SizedBox(
                  width: dimensions.width,
                  height: 150,
                  child: PageView(
                    controller: nextGamesController,
                    children: gameController.nextGames.take(3).map((game){                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: CardGameWidget(
                          width: dimensions.width - 10,
                          event: event,
                          game: game!,
                          gameDate: "Hoje",
                          navigate: false,
                          active: true,
                          route: 'config',
                        ),
                      );
                    }).toList()
                  )
                ),
                IndicatorPageWidget(pageController: nextGamesController, options: gameController.nextGames.take(3).length),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Jogadores Presentes',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    ButtonTextWidget(
                      text: "Ver Mais",
                      icon: LineAwesomeIcons.plus_solid,
                      width: 100,
                      height: 20,
                      textColor: AppColors.green_300,
                      backgroundColor: Colors.transparent,
                      action: () {},
                    )
                  ],
                ),
                SizedBox(
                  height: 210,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 15,
                      children: event.participants!.take(5).map((item){
                        //RESGATAR PARTICIPANT
                        ParticipantModel participant = item;
                        return CardPlayerGameWidget(participant: participant);
                      }).toList(),
                    )
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'MVP',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const CardMvpWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Destaques',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Column(
                  spacing: 10,
                  children: highlightsPlayers.map((player){
                    return Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dark_500.withAlpha(30),
                              spreadRadius: 0.5,
                              blurRadius: 5,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: CircleAvatar(
                                        backgroundImage: ImgUtils.getUserImg(player.user.photo)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${player.user.firstName} ${player.user.lastName}",
                                            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            "@${player.user.userName}",
                                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                              color: AppColors.gray_300,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          PositionWidget(
                                            position: player.user.player!.mainPosition,
                                            mainPosition: true,
                                            width: 35,
                                            height: 25,
                                            textSide: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.green_300.withAlpha(50),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "3 Gols",
                                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                          color: AppColors.green_300,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Icon(
                                        Icons.sports_soccer,
                                        size: 30,
                                        color: AppColors.green_300,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ]
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}