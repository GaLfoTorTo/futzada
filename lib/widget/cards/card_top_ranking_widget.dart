import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/cards/card_ranking_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class CardTopRankingWidget extends StatelessWidget {
  final List<Map<String, dynamic>> ranking;
  final PageController controller;
  
  const CardTopRankingWidget({
    super.key, 
    required this.ranking,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    return Center(
      child: Container(
        height: 380,
        width: dimensions.width,
        child: PageView(
          controller: controller,
          children: ranking.map((item) {
            //RESGATAR DADOS DO RANK
            var rank = item['ranking'];
            //RESGATAR DADOS DA PELADA
            var pelada = item['pelada'];
            //RESGATAR DADOS DOS JOGADORES
            var jogadores = item['jogadores'];
            return Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.green_300,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_500.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ImgCircularWidget(
                        width: 30,
                        height: 30,
                        image: pelada['image'],
                        borderColor: AppColors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          pelada['titulo'],
                          style: const TextStyle(
                            color: AppColors.blue_500,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Ranking por $rank',
                    style: const TextStyle(
                      color: AppColors.blue_500,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[ 
                      for(var jogador in jogadores)
                        CardRankingWidget(
                          width: jogador['colocacao'] == '1' ? 120 : 100,
                          height: jogador['colocacao'] == '1' ? 200 : 180,
                          usuario: jogador,
                          indicador: rank,
                        )
                    ]
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}