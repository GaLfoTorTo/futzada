import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/rank_controller.dart';
import 'package:futzada/widget/cards/card_podium_widget.dart';
import 'package:futzada/widget/cards/card_rank_position_widget.dart';

class EventRankPage extends StatelessWidget {
  const EventRankPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE RANK E EVENTO
    RankController rankController = RankController.instance;

    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Rankings da Pelada",
                  style: Theme.of(context).textTheme.titleMedium
                ),
                Text(
                  "Acompanhe de perto os jogadores e técnicos que se destacam na pelada com as melhores pontuações para cada tipo de estatística.",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Obx((){
            return CardPodiumWidget(
              rank: rankController.topRanking.take(3).toList(),
              title: rankController.type.value
            );
          }),
          Obx((){
            if(rankController.topRanking.isNotEmpty){
              return CardRankPositionWidget(
                rank: rankController.topRanking.skip(3).take(7).toList(),
                type: rankController.type.value,
              );
            }
            return Container();
          }),
        ]
      ),
    );
  }
}