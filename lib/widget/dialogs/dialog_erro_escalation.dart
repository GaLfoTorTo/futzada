import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class DialogErrorEscalation extends StatelessWidget {
  const DialogErrorEscalation({super.key});

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
                'Você não esta participando de nenhuma pelada',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.error_outline,
              size: 150,
              color: AppColors.red_300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Parece que você não tem peladas ativas ou permissão de técnico habilitadas. Entre em uma nova pelada ou ajuste suas configurações para escalar.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                ButtonTextWidget(
                  text: "Buscar Pelada",
                  width: dimensions.width,
                  icon: AppIcones.apito,
                  action: () => Get.toNamed('/explore/map'),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                ButtonOutlineWidget(
                  text: "Configurar Técnico",
                  width: dimensions.width,
                  icon: AppIcones.cog_solid,
                  action: (){},
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}