import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class ErroGameDialog extends StatelessWidget {
  const ErroGameDialog({super.key});

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
                'Sua pelada não tem nenhuma partida agendada',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.play_disabled_rounded,
              size: 200,
              color: AppColors.blue_500,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Parece que sua peladas não tem nenhuma partida ao vivo ou agendada. Inicie uma nova partida agora ou entre em contato com o organizador ou colaboradores da pelada.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                ButtonTextWidget(
                  text: "Iniciar Partida",
                  width: dimensions.width,
                  icon: Icons.play_arrow_rounded,
                  iconSize: 30,
                  action: () => Get.toNamed('/explore/map'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}