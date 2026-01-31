import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/helpers/event_helper.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/data/models/game_event_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/widget/indicators/indicator_live_widget.dart';

class CardGameDetailWidget extends StatefulWidget {
  final EventModel event;
  final GameModel game;
  
  const CardGameDetailWidget({
    super.key,
    required this.event,
    required this.game,
  });

  @override
  State<CardGameDetailWidget> createState() => _CardGameDetailWidgetState();
}

class _CardGameDetailWidgetState extends State<CardGameDetailWidget> {
  //RESGATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //ESTADO - ITEMS EVENTO
  late Color eventColor;
  late Color eventTextColor;
  late String eventImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ESTADO - ITEMS EVENTO
    eventColor = ModalityHelper.getEventModalityColor(widget.event.gameConfig?.category ?? widget.event.modality!.name)['color'];
    eventTextColor = ModalityHelper.getEventModalityColor(widget.event.gameConfig?.category ?? widget.event.modality!.name)['textColor'];
    eventImage = ModalityHelper.getEventModalityColor(widget.event.gameConfig?.category ?? widget.event.modality!.name)['image'];
  }

  //FUNÇÃO DE AGRUPAMENTO DE EVENTOS DE GOL DO JOGADOR
  Map<int, List<int>> groupGoalsByPlayer(List<GameEventModel> gameEvents) {
    //
    final Map<int, List<int>> grouped = {};

    for (final gameEvent in gameEvents) {
      final user = EventHelper.getUserEvent(gameController.event, gameEvent.userId!);
      if (user == null) continue;
      //ADICIONAR JOGADOR
      grouped.putIfAbsent(user.id!, () => []);
      grouped[user.id]?.add(gameEvent.minute ?? 0);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
        
    return Container(
      width: dimensions.width,
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark_500.withAlpha(30),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          //NOME EVENTO
          Text(
            "${widget.event.title}",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: AppColors.grey_500,
            ),
          ),
          //PLACAR
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: eventColor,
              image: DecorationImage(
                image: AssetImage(eventImage) as ImageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  eventColor.withAlpha(200), 
                  BlendMode.srcATop,
                )
              ),
            ),
            child: Row(
              children: [
                //TIME A
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        gameController.currentGame.teams!.first.name!,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: eventTextColor
                        )
                      ),
                      SvgPicture.asset(
                        AppIcones.emblemas[gameController.currentGame.teams!.first.emblem]!,
                        width: 100,
                        height: 100,
                        colorFilter: ColorFilter.mode(
                          eventTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        'Home',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: eventTextColor
                        )
                      ),
                    ],
                  ),
                ),
                //CRONOMETRO E PLACAR
                Obx(() {
                  final teamAScore = gameController.teamAScore.value;
                  final teamBScore = gameController.teamBScore.value;

                  //RESGATAR TEMPO DA PARTIDA
                  final currentTime = gameController.currentTime.value;
                  final parts = currentTime.split(':');
                  final minutes = int.tryParse(parts[0]) ?? 0;
                  //VERIFICAR SE TEMPO ULTRAPAÇOU LIMITE DA PARTIDA
                  final isExtraTime = minutes > (widget.game.duration ?? 0);
                  //PLACAR
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //INDICADOR DE AO VIVO
                      if (gameController.currentGame.status == GameStatus.In_progress)...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.red_300,
                          ),
                          child: const IndicatorLiveWidget(
                            size: 15,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                      //PLACAR
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Text(
                              "$teamAScore",
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: eventTextColor,
                                fontSize: 60
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'X', 
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: eventTextColor
                                )
                              ),
                            ),
                            Text(
                              "$teamBScore",
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: eventTextColor,
                                fontSize: 60
                              )
                            ),
                          ],
                        ),
                      ),
                      //TEMPORIZADOR
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: AppColors.dark_300,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              currentTime,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DS-DIGITAL',
                                color: isExtraTime ? AppColors.red_300 : AppColors.green_300,
                              ),
                            ),
                          ),
                          
                          if(isExtraTime) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Tempo Extra",
                                style: TextStyle(
                                  color: AppColors.red_300,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  );
                }),
                //TEAM B
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        gameController.currentGame.teams!.last.name!,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: eventTextColor
                        )
                      ),
                      SvgPicture.asset(
                        AppIcones.emblemas[gameController.currentGame.teams!.last.emblem!]!,
                        width: 100,
                        height: 100,
                        colorFilter: ColorFilter.mode(
                          eventTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        'Away',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: eventTextColor
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //REGISTRADOR DE EVENTOS DA PARTIDA
          Obx((){
            final game = gameController.currentGame;
            final temAGameEvents = gameController.gameEvents.where((t) => t.teamId == game.teams!.first.id).toList();
            final temBGameEvents = gameController.gameEvents.where((t) => t.teamId == game.teams!.last.id).toList();
            return  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(2, (i){
                //RESGATAR EVENTOS PRA CADA TIME
                final teamGameEvents = i == 0 ? temAGameEvents : temBGameEvents;
                if(teamGameEvents.isEmpty) return Container();
                //AGRUPAR GOLS POR JOGADOR
                final groupedGoals = groupGoalsByPlayer(teamGameEvents.where((e) => e.type?.name == 'Goal').toList());

                return SizedBox(
                  width: dimensions.width * 0.37,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 5,
                    children: groupedGoals.entries.map((entry) {
                      final playerId = entry.key;
                      final minutes = entry.value..sort();
                      final event = teamGameEvents.firstWhere(
                        (e) => EventHelper.getUserEvent(gameController.event, e.userId!)!.id == playerId,
                      );
                  
                      final user = EventHelper.getUserEvent(gameController.event, event.userId!)!;
                      return Row(
                        spacing: 5,
                        children: [
                          if(i == 0)...[
                            const Icon(
                              AppIcones.futebol_ball_solid,
                              size: 12,
                              color: AppColors.grey_500,
                            ),
                            Text(
                              UserHelper.getFullName(user),
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: AppColors.grey_500
                              ),
                            ),
                            Flexible(
                              child: Text(
                                minutes.map((m) => "$m'").join(', '),
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: AppColors.grey_500
                                ),
                                softWrap: true,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                          if(i == 1)...[
                            Flexible(
                              child: Text(
                                minutes.map((m) => "$m'").join(', '),
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: AppColors.grey_500
                                ),
                                softWrap: true,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Text(
                              "${user.firstName} ${user.lastName}",
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: AppColors.grey_500
                              ),
                            ),
                            const Icon(
                              AppIcones.futebol_ball_solid,
                              size: 12,
                              color: AppColors.grey_500,
                            )
                          ]
                        ],
                      );
                    }).toList(),
                  ),
                );
              })
            );
          }),
        ],
      ),
    );
  }
}