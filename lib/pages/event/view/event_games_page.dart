import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EventGamesPage extends StatefulWidget {
  final EventModel event;
  
  const EventGamesPage({
    super.key,
    required this.event
  });

  @override
  State<EventGamesPage> createState() => _EventGamesPageState();
}

class _EventGamesPageState extends State<EventGamesPage> {
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENT
    EventModel event = widget.event;
    //CONTROLLER DE BARRA NAVEGAÇÃO
    EventController controller = EventController.instace;
    //CONTROLLER DE BARRA NAVEGAÇÃO
    GameController gameController = GameController.instace;
    //RESGATAR PARTIDA ATUAL
    //GameModel currentGame = gameController.currentGame;
    //CONTROLLADOR DE DESTAQUES
    final PageController matchsController = PageController();

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.red_300,
                    ),
                    child: IndicatorLiveWidget(
                      size: 15,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: dimensions.width - 10,
              height: 300,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
              child: Column(
                children: [

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Próximas partidas',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  ButtonTextWidget(
                    text: "Ver Mais",
                    width: 80,
                    height: 20,
                    textColor: AppColors.green_300,
                    backgroundColor: Colors.transparent,
                    action: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
                width: dimensions.width,
                height: 250,
                child: PageView(
                  controller: matchsController,
                  children: [
                    ...controller.highlights.map((item) {

                      return Container(
                        width: dimensions.width,
                        height: 200,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                        child: Row(
                          children: [
                          ],
                        ),
                      );
                    }),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SmoothPageIndicator(
                  controller: matchsController,
                  count: controller.highlights.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.blue_500,
                    dotColor: AppColors.gray_300,
                    expansionFactor: 2,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Histórico',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Container(
              width: dimensions.width - 10,
              height: 150,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
              child: Column(
                children: [

                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}