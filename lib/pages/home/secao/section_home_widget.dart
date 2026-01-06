import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/utils/map_utils.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/cards/card_day_event_widget.dart';
import 'package:futzada/widget/cards/card_event_today_widget.dart';
import 'package:futzada/widget/cards/card_to_you_widget.dart';
import 'package:futzada/widget/cards/card_popular_widget.dart';
import 'package:futzada/widget/cards/card_top_ranking_widget.dart';
import 'package:futzada/widget/cards/card_ultimos_jogos_widget.dart';
import 'package:futzada/widget/indicators/indicator_page_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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

    Widget cardSelected(String titulo){
      switch (titulo) {
        case "Dia de Jogo":
          return CardDayEventWidget(
            events: options as List<EventModel>,
            pageController: pageController
          );
        case "Perto de Você":
          return CardToYouWidget(
            events: options as List<EventModel>, 
            pageController: pageController
          );
        case "Mais Populares":
          return CardPopularWidget(
            events: options as List<EventModel>,
            pageController: pageController
          );
        case "Acontece Hoje":
          return CardEventTodayWidget(
            events: options as List<EventModel>,
            pageController: pageController
          );
        case "Top Ranking":
          return CardTopRankingWidget(
            ranking: options as List<Map<String, dynamic>>,
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
      spacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: Theme.of(context).textTheme.headlineSmall
              ),
              if(titulo == 'Dia de Jogo' )...[
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.green_300.withAlpha(30),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppColors.green_300,
                      ),
                      Text(
                        MapUtils.getLocation(),
                        style: const TextStyle(
                          color: AppColors.green_300,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ) 
              ]else...[
                ButtonTextWidget(
                  text: "Ver Mais",
                  icon: LineAwesomeIcons.plus_solid,
                  width: 100,
                  height: 20,
                  textColor: AppColors.green_300,
                  backgroundColor: Colors.transparent,
                  action: () {},
                ) 
              ]
            ]
          ),
        ),
        cardSelected(titulo),
        IndicatorPageWidget(pageController: pageController, options: options.take(5).length),
      ],
    );
  }
}