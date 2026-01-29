import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/buttons/button_outline_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';

class ErroEventPage extends StatelessWidget {
  const ErroEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR COR APARTIR DO TEMA
    final backgroundColor = Get.isDarkMode ? AppColors.dark_500 : AppColors.white;

    return  Container(
      width: dimensions.width,
      height: dimensions.height * 0.90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor.withAlpha(50),
            backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Você não esta participando de nenhuma pelada!',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const Icon(
            Icons.sports,
            size: 150,
          ),
          Text(
            'Parece que você não está participando de nenhuma peladas ainda. Entre em uma nova pelada ou crie seu proprio evento de pelada para começar a jogar.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Column(
            spacing: 10,
            children: [
              ButtonTextWidget(
                text: "Buscar Pelada",
                width: dimensions.width,
                icon: AppIcones.apito,
                action: () => Get.toNamed('/explore/map'),
              ),
              ButtonOutlineWidget(
                text: "Criar Pelada",
                width: dimensions.width,
                icon: Icons.add_rounded,
                action: () => Get.toNamed('/event/register/basic'),
              )
            ],
          )
        ],
      ),
    );
  }
}