import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class ErroHistoricGamePage extends StatelessWidget {
  const ErroHistoricGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return  Container(
      width: dimensions.width,
      height: dimensions.height - 150,
      padding: const EdgeInsets.all(10),
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
              'Nenhuma partida finalizada',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(
            Icons.history_rounded,
            size: 200,
            color: AppColors.blue_500,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Parece que sua peladas não tem nenhuma partida finalizada até o momento. Quando uma partida e finalizada e será armazenada no histórico de acordo com o dia e mes de acontecimento.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}