import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/animated/animated_ellipsis.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';

class CardGameDetailWidget extends StatelessWidget {
  final EventModel event;
  final GameModel game;
  
  const CardGameDetailWidget({
    super.key,
    required this.event,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE PARTIDA
    final gameController = GameController.instance;
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //GERAR NUMERO ALEATORIO PARA INDEX DE EMBLEMAS
    int indexA = Random().nextInt(8);
    int indexB = Random().nextInt(8);
    //GERAR INDEX ALEATORIO PARA EMBLEMA DE EQUIPES
    String emblemaIndexA = "emblema_${indexA == 0 ? 1 : indexA}";
    String emblemaIndexB = "emblema_${indexB == 0 ? 1 : indexB}";
    
    return Container(
      width: dimensions.width,
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
      child: Column(
        children: [
          //NOME EVENTO
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${event.title}",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.gray_500,
                  ),
                ),
              ],
            ),
          ),
          //PLACAR
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 15),
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
              children: [
                //TIME A
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Team A",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.blue_500
                        )
                      ),
                      Container(
                        width: 100,
                        height: 100,
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
                          AppIcones.emblemas[emblemaIndexA]!,
                          width: 50,
                          height: 50,
                          colorFilter: const ColorFilter.mode(
                            AppColors.gray_300, 
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final isRunning = gameController.isGameRunning;
                  final teamAScore = gameController.teamAScore.value;
                  final teamBScore = gameController.teamBScore.value;
                  //PLACAR
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //INDICADOR DE AO VIVO
                      if (isRunning)...[
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
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "$teamAScore",
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: AppColors.gray_500
                                )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'X', 
                                style: Theme.of(context).textTheme.titleLarge
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "$teamBScore",
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: AppColors.gray_500
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      //INDICADOR DE AO VIVO (DOTS)
                      if (isRunning)...[
                        Container(
                          height: 20,
                          width: 30,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(100),
                            borderRadius: const  BorderRadius.all(Radius.circular(5))
                          ),
                          child: const AnimatedEllipsis(
                            dotSize: 5,
                            dotColor: AppColors.white,
                          ),
                        ),
                      ]
                    ],
                  );
                }),
                //TEAM B
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Team B",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.blue_500
                        )
                      ),
                      Container(
                        width: 100,
                        height: 100,
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
                          AppIcones.emblemas[emblemaIndexB]!,
                          width: 50,
                          height: 50,
                          colorFilter: const ColorFilter.mode(
                            AppColors.gray_300, 
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //CRONOMETRO
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const ImgGroupCircularWidget(
                  width: 30,
                  height: 30,
                  side: "right",
                  images: null,
                ),
                Obx(() {
                  //RESGATAR TEMPO DA PARTIDA
                  final currentTime = gameController.currentTime.value;
                  final parts = currentTime.split(':');
                  final minutes = int.tryParse(parts[0]) ?? 0;
                  //VERIFICAR SE TEMPO ULTRAPAÇOU LIMITE DA PARTIDA
                  final isExtraTime = minutes > (game.duration ?? 0);

                  return Column(
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
                  );
                }),
                const ImgGroupCircularWidget(
                  width: 30,
                  height: 30,
                  side: "right",
                  images: null,//teamA.take(3)
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}