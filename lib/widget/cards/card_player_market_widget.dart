import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futzada/models/player_model.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class CardPlayerMarketWidget extends StatefulWidget {
  final PlayerModel player;
  final Map<int, dynamic> escalation;
  
  const CardPlayerMarketWidget({
    super.key,
    required this.player,
    required this.escalation,
  });

  @override
  State<CardPlayerMarketWidget> createState() => CardPlayerMarketWidgetState();
}

class CardPlayerMarketWidgetState extends State<CardPlayerMarketWidget> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instace;
  //CONTROLADOR DE POSICAO PRINCIPAL
  String? position;

  @override
  void initState() {
    super.initState();
    //ADICIONAR A FLAG DE POSIÇÃO PRINCIPAL
    loadPosition();
  }

  //FUNÇÃO PARA CARREGAR ICONE DE POSIÇÃO DO JOGADOR
  Future<void> loadPosition() async {
    //TENTAR CARREGAR SVG DE POSIÇÃO COMO STRING
    try {
      var string_position = await AppHelper.mainPosition(AppIcones.posicao[widget.player.mainPosition]);
      position = string_position;
    } catch (e) {
      position = null;
    }
    //ATUALIZAR STATE
    setState(() {});
  }

  //FUNÇÃO PARA DEFINIR TIPO DE BOTÃO
  Map<String, dynamic> setButtonBuy(player){
    /* 
    //VERIFICAR SE USUARIO TEM FUTCOIN O SUFICIENTE PARA COMPRAR JOGADOR, SE NÃO RETORNAR BOTÃO DESABILITADO
    if(user[futcoin] < player.price){
      return{
        'text':'Comprar',
        'color' : AppColors.gray_300,
        'disabled': true
      };
    }
    */
    //VERIFICAR SE JOGADOR ESTA NA ESCALAÇÃO
    final isEscaled = controller.findPlayerEscalation(player.id);
    //VERIFICAR SE JOGADOR ESTA NA ESCALAÇÃO DO USUARIO
    if(isEscaled){
      return{
        'text':'Vender',
        'color' : AppColors.red_300,
        'disabled': false
      };
    }
    return{
      'text':'Comprar',
      'color' : AppColors.green_300,
      'disabled': true
    };
  }

  //FUNÇÃO PARA ADICIONAR OU REMOVER JOGADOR DA ESCALAÇÃO
  void setPlayerPosition(uuid){
    //SELECIONAR JOGADOR
    controller.setPlayerEscalation(uuid);
    //NAVEGAR DE VOLTA PARA ESCALAÇÃO
    Get.back();
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    //RESGATAR JOGADOR
    PlayerModel player = widget.player;
    
    //RESGTAR JOGADOR COMO MAP
    Map<String, dynamic> playerMap = widget.player.toMap();
    
    //RESGATAR POSIÇÕES DO JOGADOR
    List<dynamic> playerPositions = jsonDecode(player.positions);
    
    //REMOVER POSIÇÃO PRINCIPAL DO ARRAY
    playerPositions.remove(player.mainPosition);
    
    //LISTA DE METRICAS DO CARD
    Map<String, dynamic> metrics = {
      'lastPontuation':'Última pontuação', 
      'media': 'Media',
      'games':'jogos'
    };

    return Container(
      width: dimensions.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark_500.withAlpha(30),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImgCircularWidget(
                  height: 80,
                  width: 80,
                  image: player.user.photo,
                  borderColor: AppColors.gray_300,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: (dimensions.width / 2) - 50,
                        child: Text(
                          "${player.user.firstName} ${player.user.lastName}",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(
                        width: (dimensions.width / 2) - 50,
                        child: Text(
                          "@${player.user.userName}",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(overflow: TextOverflow.ellipsis, color: AppColors.gray_300),
                        ),
                      ),
                      SizedBox(
                        width: (dimensions.width / 2) - 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if(position != null)...[
                                    SvgPicture.string(
                                      position!,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ]else...[
                                    Container(
                                      width: 35,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        color: AppColors.gray_300,
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                      ),
                                    )
                                  ],
                                  ...playerPositions.asMap().entries.map((entry){
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: SvgPicture.asset(
                                        AppIcones.posicao[entry.value]!,
                                        width: 15,
                                        height: 15,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(
                              child:Icon(
                                AppHelper.setStatusPlayer(player.status)['icon'],
                                color: AppHelper.setStatusPlayer(player.status)['color'],
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Fz\$",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.gray_300),
                      ),
                      Text(
                        "${player.price}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "${player.valorization}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppHelper.setColorPontuation(player.valorization)['color'], fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        AppHelper.setColorPontuation(player.valorization)['icon'],
                        size: 15,
                        color: AppHelper.setColorPontuation(player.valorization)['color'],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...metrics.entries.map((entry){
                  final key = entry.key;
                  final label = entry.value;
                  final itemWidth = key == 'lastPontuation' ? (dimensions.width / 3) : (dimensions.width / 3) - 30;
                  return Container(
                    width: itemWidth,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.gray_300.withAlpha(40),
                      borderRadius: const BorderRadius.all(Radius.circular(5))
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${playerMap[key]}",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppHelper.setColorPontuation(playerMap[key])['color']),
                        ),
                        Text(
                          "$label",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  );
                }),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonTextWidget(
                  text: "Ver Detalhes",
                  height: 30,
                  width: 100,
                  textColor: AppColors.white,
                  backgroundColor: AppColors.green_300,
                  action: (){},
                ),
                ButtonTextWidget(
                  text: setButtonBuy(player)['text'],
                  height: 30,
                  width: 100,
                  textColor: AppColors.white,
                  backgroundColor: setButtonBuy(player)['color'],
                  disabled: setButtonBuy(player)['disabled'],
                  action: () => setPlayerPosition(player.id),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}