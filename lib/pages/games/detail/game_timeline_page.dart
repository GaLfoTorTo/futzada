import 'package:futzada/models/game_event_model.dart';
import 'package:futzada/services/game_event_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:futzada/controllers/game_controller.dart';

class GameTimelinePage extends StatefulWidget {
  const GameTimelinePage({super.key});

  @override
  State<GameTimelinePage> createState() => _GameTimelinePageState();
}

class _GameTimelinePageState extends State<GameTimelinePage> {
  //RESGATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR SERVIÇO DE VENTOS DA PARTIDA
    GameEventService gameEventService = GameEventService();
    //RESGATAR EQUIPES
    final teamA = gameController.currentGame.teams!.first;
    final teamB = gameController.currentGame.teams!.last;

    //FUNÇÃO DE CONSTRUÇÃO DE EVENTO DA TIMELINE
    Widget buildTimelineTile(GameEventModel event) {
      return TimelineTile(
        alignment: TimelineAlign.center,
        lineXY: 0.2,
        beforeLineStyle: const LineStyle(color: AppColors.gray_300, thickness: 1),
        afterLineStyle: const LineStyle(color: AppColors.gray_300, thickness: 1),
        indicatorStyle: IndicatorStyle(
          height: 30,
          width: 30,
          padding: const EdgeInsets.symmetric(vertical: 5),
          indicator: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.gray_300),
              borderRadius: BorderRadius.circular(20)
            ),
            alignment: Alignment.center,
            child: Text(
              "${event.minute}'",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.gray_300
              ),
            ),
          )
        ),
        startChild: teamA == event.team 
          ? ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  children: [
                    Expanded(
                      child: Text(
                        gameEventService.getActionGameEvent(event.type)['title'],
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Icon(
                      gameEventService.getActionGameEvent(event.type)['icon'],
                      size: 25,
                      color: event.type?.name == "YellowCard" ? AppColors.yellow_300 : ( event.type?.name == "RedCard" ? AppColors.red_300 : AppColors.gray_500 ),
                    ),
                  ],
                ),
              ),
              subtitle:Text(
                event.description!,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            )
          : null,
        endChild: teamB == event.team
          ? ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  children:[
                    Icon(
                      gameEventService.getActionGameEvent(event.type)['icon'],
                      size: 25,
                      color: event.type?.name == "YellowCard" ? AppColors.yellow_300 : ( event.type?.name == "RedCard" ? AppColors.red_300 : AppColors.gray_500 ),
                    ),
                    Expanded(
                      child: Text(
                        gameEventService.getActionGameEvent(event.type)['title'],
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle:Text(
                event.description!,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            )
          : null,
      );
    }

    //FUNÇÃO DE CRIAÇÃO DE WIDGET DE INICIO E FIM DE TEMPOS
    Widget buildTimeLineStartEnd(event){
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
          border: Border.all(color: AppColors.gray_300),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            const Icon(
              Icons.timer_outlined,
              size: 25,
              color: AppColors.gray_300,
            ),
            Text(
              gameEventService.getActionGameEvent(event.type)['title'],
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.gray_300,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          color: Get.isDarkMode ?AppColors.dark_300 : AppColors.white,
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
          if(gameController.gameEvents.isEmpty){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Text(
                  "A partida será iniciada em instantes, aguarde!",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.gray_300,
                  ),
                ),
                const Icon(
                  Icons.sports,
                  size: 50,
                  color: AppColors.gray_300,
                )
              ],
            );
          }
          //TIMELINE DE EVENTOS
          return ListView.builder(
            itemCount: gameController.gameEvents.length,
            itemBuilder: (context, index) {
              final event = gameController.gameEvents[index];
              if(
                event.type?.name == 'StartGame' || 
                event.type?.name == 'EndGame' || 
                event.type?.name == 'HalfTimeStart' || 
                event.type?.name == 'HalfTimeEnd' || 
                event.type?.name == 'ExtraTime' ||
                event.type?.name == 'ExtraTimeStart' ||
                event.type?.name == 'ExtraTimeEnd'
              ){
                return buildTimeLineStartEnd(event);
              }
              return buildTimelineTile(event);
            },
          );
        })
    );
  }
}