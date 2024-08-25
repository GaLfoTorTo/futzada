import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/cards/card_ranking_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';
import 'package:futzada/widget/others/user_stack_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CardUltimosJogosWidget extends StatelessWidget {
  final List<Map<String, dynamic>> partidas;
  final PageController controller;
  
  const CardUltimosJogosWidget({
    super.key, 
    required this.partidas,
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
          children: partidas.map((item) {
            //RESGATAR DADOS DA PELADA
            var pelada = item['pelada'];
            //RESGATAR DADOS DOS JOGADORES
            List<Map<String, dynamic>> equipes = item['equipes'];
            return Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10,),
              padding: const EdgeInsets.all(10),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        pelada['data'],
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        pelada['local'],
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        pelada['hora'],
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          AppIcones.emblemas["emblema_1"]!,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${equipes[0]['placar']}',
                              style: TextStyle(
                                color: equipes[0]['placar'] > equipes[1]['placar'] ? AppColors.blue_500 : AppColors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'x',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              '${equipes[1]['placar']}',
                              style: TextStyle(
                                color: equipes[1]['placar'] > equipes[0]['placar'] ? AppColors.blue_500 : AppColors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          AppIcones.emblemas["emblema_1"]!,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: equipes.asMap().entries.map((entry) {
                      //RESGATAR CHAVE 
                      int key = entry.key;
                      //RESGATAR EQUIPES
                      var equipe = entry.value;
                      //RESGATAR ARTILHEIROS
                      List<dynamic>? artilheiros = equipe['artilheiros'];
                      //RESGATAR ASSISTENCIAS
                      List<dynamic>? assistentes = equipe['assistentes'];
                      return Column(
                        children: [
                          Padding(
                            padding: key == 0 ? const EdgeInsets.only(right: 30) : const EdgeInsets.only(left: 30),
                            child: UserStackWidget(
                              usuarios: artilheiros,
                              icone: LineAwesomeIcons.futbol,
                              side: key == 0 ? 'right' : 'left',
                            ),
                          ),
                          Padding(
                            padding: key == 0 ? const EdgeInsets.only(right: 30) : const EdgeInsets.only(left: 30),
                            child: UserStackWidget(
                              usuarios: assistentes,
                              icone: LineAwesomeIcons.hand_holding_solid,
                              side: key == 0 ? 'right' : 'left',
                            )
                          )
                        ],
                      );
                    }).toList(),
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