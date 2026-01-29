import 'package:futzada/presentation/widget/indicators/indicator_live_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/data/models/team_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/widget/animated/animated_ellipsis.dart';
import 'package:futzada/presentation/widget/others/timer_counter_widget.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

class CardGameLiveWidget extends StatefulWidget {
  final EventModel event;
  final GameModel game;
  const CardGameLiveWidget({
    super.key,
    required this.event,
    required this.game,
  });

  @override
  State<CardGameLiveWidget> createState() => _CardGameLiveWidgetState();
}

class _CardGameLiveWidgetState extends State<CardGameLiveWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;
    //RESGATAR PARTIDA 
    GameModel game = widget.game;
    //RESGATAR EQUIPES DA PARTIDA
    TeamModel teamA = widget.game.teams!.first;
    TeamModel teamB = widget.game.teams!.last;

    return InkWell(
      onTap: (){
        //DEFINIR PARTIDA ATUAL
        gameController.setCurrentGame(widget.game);
        //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
        Get.toNamed('/games/overview');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: dimensions.width - 10,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.green_300,
          image: DecorationImage(
            image: const AssetImage(AppImages.cardFootball) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.green_300.withAlpha(220), 
              BlendMode.srcATop,
            )
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(50),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Obx(() {
          //RESGATAR PLACAR DA PARTIDA
          final teamAScore = gameController.teamAScore.value;
          final teamBScore = gameController.teamBScore.value;

          return Column(
            children: [
              Container(
                width: 150,
                decoration: const BoxDecoration(
                  color: AppColors.red_300,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: IndicatorLiveWidget(
                    size: 15,
                    color: AppColors.white,
                  ),
                ),
              ),
              Text(
                "#${game.number}",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.blue_500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcones.emblemas["emblema_1"]!,
                          width: 60,
                          colorFilter: const ColorFilter.mode(
                            AppColors.blue_500,
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "${teamA.name}",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: AppColors.blue_500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "$teamAScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 40,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Text(
                    ":",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 35,
                      color: AppColors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "$teamBScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 40,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcones.emblemas['emblema_2']!,
                          width: 60,
                          colorFilter: const ColorFilter.mode(
                            AppColors.blue_500, 
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "${teamB.name}",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: AppColors.blue_500,
                            ),
                          ),
                        ),
                      ],
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
                        game: widget.game,
                        color: AppColors.white
                      ),
                      Container(
                        height: 20,
                        width: 50,
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.white.withAlpha(100),
                          borderRadius: const BorderRadius.all(Radius.circular(5))
                        ),
                        child: const AnimatedEllipsis(
                          dotSize: 5,
                          dotColor: AppColors.white,
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