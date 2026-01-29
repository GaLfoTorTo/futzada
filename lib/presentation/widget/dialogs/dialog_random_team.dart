import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_loading_widget.dart';

class DialogRandomTeam extends StatelessWidget {
  final Future<void> Function() actionRandom;
  final Future<void> Function() actionOrder;
  const DialogRandomTeam({
    super.key,
    required this.actionRandom,
    required this.actionOrder,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return  Dialog(
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
              spacing: 10,
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
                      loadingWidget: const Center(child: IndicatorLoadingWidget()),
                      opacity: 0.7,
                      opacityColor: AppColors.dark_700
                    );
                    //FECHAR DIALOG
                    Get.back();
                  },
                ),
                ButtonTextWidget(
                  text: "Ordem",
                  width: dimensions.width,
                  icon: Icons.format_list_numbered_rounded,
                  iconSize: 30,
                  action: () async {
                    //EXECUTAR FUNÇÃO RANDOMICA E EXIBIR OVERLAY
                    await Get.showOverlay(
                      asyncFunction: actionRandom,
                      loadingWidget: const Center(child: IndicatorLoadingWidget()),
                      opacity: 0.7,
                      opacityColor: AppColors.dark_700
                    );
                    //FECHAR DIALOG
                    Get.back();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}