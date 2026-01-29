import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/buttons/button_outline_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';

class ErroEscalationPage extends StatelessWidget {
  const ErroEscalationPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR COR APARTIR DO TEMA
    final backgroundColor = Get.isDarkMode ? AppColors.dark_500 : AppColors.white;

    return  Container(
      width: dimensions.width,
      height: dimensions.height,
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
            'Você não esta participando de nenhuma pelada',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const Icon(
            Icons.error_outline,
            size: 150,
          ),
          Text(
            'Parece que você não tem peladas ativas ou permissão de técnico habilitadas. Entre em uma nova pelada ou ajuste suas configurações para escalar.',
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
                text: "Configurar Técnico",
                width: dimensions.width,
                icon: AppIcones.cog_solid,
                action: (){},
              )
            ],
          )
        ],
      ),
    );
  }
}