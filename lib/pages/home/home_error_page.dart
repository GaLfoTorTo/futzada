import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';

class HomeErrorPage extends StatelessWidget {
  const HomeErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Container(
      width: dimensions.width,
      height: dimensions.height - 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.white.withAlpha(50),
            AppColors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Ops! Houve um erro ao carregar o app.',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(
            Icons.no_cell_rounded,
            size: 200,
            color: AppColors.blue_500,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Parece que houve um erro ao carregar o app. Verifique sua conexão de internet e tente novamente.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              ButtonTextWidget(
                text: "Recarregar",
                width: dimensions.width,
                icon: Icons.restart_alt_rounded,
                iconSize: 30,
                action: () {}
              ),
            ],
          )
        ],
      ),
    );
  }
}