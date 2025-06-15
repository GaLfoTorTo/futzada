import 'dart:convert';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GameConfigDialog extends StatelessWidget {
  final EventModel event;
  final GameModel game;
  const GameConfigDialog({
    super.key,
    required this.event,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //CONTROLLADOR DE DESTAQUES
    final PageController pageController = PageController();

    return  Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Deseja salvar suas configurações de partida?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: dimensions.width,
              height: 400,
              child: PageView(
                controller: pageController,
                children: const [
                  FirstConfgGamePage(),
                  SecoundConfgGamePage(),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SmoothPageIndicator(
                controller: pageController,
                count: 2,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.blue_500,
                  dotColor: AppColors.gray_300,
                  expansionFactor: 2,
                ),
              ),
            ),
            Column(
              children: [
                ButtonTextWidget(
                  text: "Salvar e Iniciar",
                  width: dimensions.width,
                  icon: AppIcones.save_solid,
                  action: () {
                    AppHelper.feedbackMessage(context, "Configurações Salvas com sucesso", type: "Success");
                    //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
                    Get.toNamed('/games/game_detail', arguments: {
                      'game': game,
                      'event': event,
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ButtonOutlineWidget(
                  text: "Apenas Iniciar",
                  width: dimensions.width,
                  icon: AppIcones.apito,
                  action: (){
                    //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
                    Get.toNamed('/games/game_detail', arguments: {
                      'game': game,
                      'event': event,
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FirstConfgGamePage extends StatelessWidget {
  const FirstConfgGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 60,
                left: dimensions.width / 5,
                child: Icon(
                  Icons.content_paste_go_rounded,
                  size: 120,
                  color: AppColors.blue_500,
                ),
              ),
              Positioned(
                top: 123,
                left: dimensions.width / 3.2,
                child: Icon(
                  AppIcones.cog_solid,
                  size: 105,
                  color: AppColors.blue_500,
                ),
              ),
            ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Você pode salvar suas configurações de partida para reutiliza-las toda vez que for iniciar uma nova partida.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class SecoundConfgGamePage extends StatelessWidget {
  const SecoundConfgGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child:  Icon(
            AppIcones.stopwatch_solid,
            size: 150,
            color: AppColors.blue_500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Informações de duração, árbitros, quantidade de jogadores por equipe, etc. Tudo isso pode ser salvo para auxiliar na inicialização de novas partidas futuramente',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}