import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/cards/card_para_voce_widget.dart';
import 'package:futzada/widget/cards/card_top_ranking_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SecaoHomeWidget extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final String titulo;

  SecaoHomeWidget({
    super.key,
    required this.options,
    required this.titulo
  });

  @override
  Widget build(BuildContext context) {
    //CONTROLLADOR DE PAGINAS
    final PageController pageController = PageController();

    Widget cardSelected(String titulo){
      switch (titulo) {
        case "Perto de Você":
          return CardParaVoceWidget(
            peladas: options, 
            controller: pageController
          );
        case "Top Ranking":
          return CardTopRankingWidget(
            ranking: options, 
            controller: pageController
          );
        default:
        return Container();
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: AppColors.blue_500,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),  
              const Text(
                'Ver Mais',
                style: TextStyle(
                  color: AppColors.red_500,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ) 
            ]
          ),
        ),
        cardSelected(titulo),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SmoothPageIndicator(
            controller: pageController,
            count: options.length,
            effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.blue_500,
                dotColor: AppColors.gray_300,
                expansionFactor: 2,
              ),
          ),
        ),
      ],
    );
  }
}