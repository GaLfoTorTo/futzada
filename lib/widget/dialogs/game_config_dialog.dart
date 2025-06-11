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
            const SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 40,
                    child: Icon(
                      Icons.content_paste_go_rounded,
                      //AppIcones.clipboard_solid,
                      size: 120,
                      color: AppColors.blue_500,
                    ),
                  ),
                  Positioned(
                    left: 85,
                    top: 93,
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
                'Você pode salvar suas configurações de partida para não precisar configurar novamente toda vez que for iniciar uma nova partida.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
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