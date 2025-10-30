import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/cards/card_day_event_widget.dart';
import 'package:futzada/widget/cards/card_to_you_widget.dart';
import 'package:futzada/widget/cards/card_popular_widget.dart';
import 'package:futzada/widget/cards/card_top_ranking_widget.dart';
import 'package:futzada/widget/cards/card_ultimos_jogos_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SectionHomeWidget extends StatelessWidget {
  final dynamic options;
  final String titulo;

  const SectionHomeWidget({
    super.key,
    required this.options,
    required this.titulo
  });

  @override
  Widget build(BuildContext context) {
    //CONTROLLADOR DE PAGINAS
    final PageController pageController = PageController();
    //TEXTO AUXILIAR
    String othertext = "Ver Mais";

    Widget cardSelected(String titulo){
      switch (titulo) {
        case "Dia de Jogo":
          return CardDayEventWidget(
            events: options as List<EventModel>,
            pageController: pageController
          );
        case "Perto de Você":
          return CardToYouWidget(
            events: options as List<Map<String, dynamic>>, 
            pageController: pageController
          );
        case "Top Ranking":
          return CardTopRankingWidget(
            ranking: options as List<Map<String, dynamic>>,
            controller: pageController
          );
        case "Mais Populares":
          return CardPopularWidget(
            popular: options as List<Map<String, dynamic>>,
            controller: pageController
          );
        case "Últimos Jogos":
          return CardUltimosJogosWidget(
            partidas: options as List<Map<String, dynamic>>,
            controller: pageController
          );
        default:
        return Container();
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
              Text(
                titulo == 'Dia de Jogo' ? "Brasília/DF" : othertext,
                style: const TextStyle(
                  color: AppColors.red_500,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ) 
            ]
          ),
        ),
        cardSelected(titulo),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
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