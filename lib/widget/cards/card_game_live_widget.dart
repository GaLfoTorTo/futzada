import 'package:futzada/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/animated/animated_ellipsis.dart';
import 'package:futzada/widget/others/timer_counter_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardGameLiveWidget extends StatelessWidget {
  final EventModel event;
  final GameModel game;
  const CardGameLiveWidget({
    super.key,
    required this.event,
    required this.game,
  });

  @override
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE PARTIDA
    final gameController = GameController.instance;

    //RESGATAR EQUIPES DA PARTIDA
    TeamModel teamA = game.teams!.first;
    TeamModel teamB = game.teams!.last;

    return InkWell(
      onTap: (){
        //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
        Get.toNamed('/games/game_detail', arguments: {
          'game': game,
          'event': event,
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: dimensions.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
        child: 
        Obx(() {
          //RESGATAR PLACAR DA PARTIDA
          final teamAScore = gameController.teamAScore.value;
          final teamBScore = gameController.teamBScore.value;

          return Column(
            children: [
              Stack(
                children:[ 
                  Container(
                    width: dimensions.width,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius:const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      image: DecorationImage(
                        image: event.photo != null 
                          ? CachedNetworkImageProvider(event.photo!) 
                          : const AssetImage(AppImages.gramado) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "#${game.number}",
                      style: Theme.of(context).textTheme.headlineLarge
                    ),
                  ),
                ]
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "${game.startTime} as ${game.endTime}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.gray_500,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
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
                      AppIcones.emblemas[teamA.emblema]!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.gray_300, 
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.green_100.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$teamAScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: teamAScore > teamBScore? AppColors.green_300 : AppColors.gray_700,
                      ),
                    ),
                  ),
                  Text(
                    "x",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.gray_300,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.green_100.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$teamBScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: teamBScore > teamAScore? AppColors.green_300 : AppColors.gray_700,
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dark_500.withAlpha(30),
                          spreadRadius: 0.7,
                          blurRadius: 5,
                          offset: const Offset(-2, 5),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      AppIcones.emblemas[teamB.emblema]!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.gray_300, 
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      TimerCounterWidget(
                        game: game,
                      ),
                      Container(
                        height: 20,
                        width: 50,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.green_100.withAlpha(100),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: const AnimatedEllipsis(
                          dotSize: 5,
                          dotColor: AppColors.green_500,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        })
      ),
    );
  }
}