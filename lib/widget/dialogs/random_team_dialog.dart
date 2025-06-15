import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';

class RandomTeamDialog extends StatelessWidget {
  final Future<bool> Function() actionRandom;
  final Future<bool> Function() actionSet;
  const RandomTeamDialog({
    super.key,
    required this.actionRandom,
    required this.actionSet
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Definição de times da partida',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.safety_divider_rounded,
              size: 200,
              color: AppColors.blue_500,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Escolha a forma como você deseja definir as equipes que disputaram a partida. Sorteio entre os jogadores confirmados ou a escolha manual as equipes.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                ButtonTextWidget(
                  text: "Sorteio",
                  width: dimensions.width,
                  icon: Icons.repeat_rounded,
                  iconSize: 30,
                  action: () async {
                    //EXECUTAR FUNÇÃO RANDOMICA E EXIBIR OVERLAY
                    await Get.showOverlay(
                      asyncFunction: actionRandom,
                      loadingWidget: Center(child: const CircularProgressIndicator(color: AppColors.green_300)),
                      opacity: 0.7,
                      opacityColor: AppColors.dark_700
                    );
                    //FECHAR DIALOG
                    Get.back();
                  },
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ButtonOutlineWidget(
                  text: "Escolher manualmente",
                  width: dimensions.width,
                  iconSize: 30,
                  action: () async {
                    //FECHAR DIALOG
                    await actionSet();
                    
                    Get.back();
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}