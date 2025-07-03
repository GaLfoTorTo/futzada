import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/models/player_model.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';

class CardPlayerMarketWidget extends StatefulWidget {
  final ParticipantModel participant;
  final Map<int, dynamic> escalation;
  
  const CardPlayerMarketWidget({
    super.key,
    required this.participant,
    required this.escalation,
  });

  @override
  State<CardPlayerMarketWidget> createState() => CardPlayerMarketWidgetState();
}

class CardPlayerMarketWidgetState extends State<CardPlayerMarketWidget> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instance;
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
      var string_position = await AppHelper.mainPosition(AppIcones.posicao[widget.participant.user.player!.mainPosition]);
      position = string_position;
    } catch (e) {
      position = null;
    }
    //ATUALIZAR STATE
    setState(() {});
  }

  //FUNÇÃO PARA DEFINIR TIPO DE BOTÃO
  Map<String, dynamic> setButtonBuy(PlayerModel player){
    //VERIFICAR SE USUARIO TEM FUTCOIN O SUFICIENTE PARA COMPRAR JOGADOR, SE NÃO RETORNAR BOTÃO DESABILITADO
    if(player.rating!.price! > controller.managerPatrimony.value){
      return{
        'text':'Comprar',
        'color' : AppColors.gray_300,
        'disabled': true
      };
    }
    //VERIFICAR SE JOGADOR ESTA NA ESCALAÇÃO
    final isEscaled = controller.findPlayerEscalation(player.id!, );
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
      'disabled': false
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
    
    //RESGATAR PARTICIPANT
    ParticipantModel participant = widget.participant;
    //RESGATAR JOGADOR
    PlayerModel player = participant.user.player!;
    //RESGTAR JOGADOR COMO MAP
    Map<String, dynamic> playerMap = player.toMap();
    
    //RESGATAR POSIÇÕES DO JOGADOR
    List<dynamic> playerPositions = jsonDecode(player.positions);
    
    //REMOVER POSIÇÃO PRINCIPAL DO ARRAY
    playerPositions.remove(player.mainPosition);
    //MAP DE STATUS
    //LISTA DE METRICAS DO CARD
    Map<String, dynamic> metrics = {
      'points':'Última pontuação', 
      'avarage': 'Media',
      'games':'jogos'
    };

    //DEFINIR CONFIGURAÇÕES DE BOTÃO DE COMPRA E VENDA DE JOGADOR
    var buttonConfig = setButtonBuy(player);

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
      child: Row(
        children: [
          SizedBox(
            width: (dimensions.width * 0.65) - 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImgCircularWidget(
                      height: 80,
                      width: 80,
                      image: participant.user.photo,
                      borderColor: AppColors.gray_300,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (dimensions.width / 2) - 50,
                            height: 25,
                            child: Text(
                              "${participant.user.firstName} ${participant.user.lastName}",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          SizedBox(
                            width: (dimensions.width / 2) - 50,
                            height: 25,
                            child: Text(
                              "@${participant.user.userName}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(overflow: TextOverflow.ellipsis, color: AppColors.gray_300),
                            ),
                          ),
                          SizedBox(
                            width: (dimensions.width / 2) - 50,
                            height: 25,
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
                                    AppHelper.setStatusPlayer(participant.status)['icon'],
                                    color: AppHelper.setStatusPlayer(participant.status)['color'],
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: (dimensions.width * 0.65) - 20,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ...metrics.entries.map((entry){
                        //RESGATAR PARAMETRO DE RATING
                        final key = entry.key;
                        //RESGATAR LABEL DE RATING
                        final label = entry.value;
                        final itemWidth = key == 'points' ? ( dimensions.width * 0.60 ) : ( dimensions.width * 0.3 ) - 5;

                        return Container(
                          width: itemWidth,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.gray_300.withAlpha(40),
                            borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),
                          child: Column(
                            children: [
                              Text(
                                "${playerMap['rating'][key] != null ? playerMap['rating'][key] : 0.0}",
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppHelper.setColorPontuation(playerMap['rating'][key])['color']),
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
              ]
            ),
          ),
          SizedBox(
            width: (dimensions.width * 0.3) - 10,
            height: 210,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Fz\$",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
                      ),
                      Text(
                        "${player.rating!.price}",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${player.rating!.valuation}",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppHelper.setColorPontuation(player.rating!.valuation)['color'], fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(
                            AppHelper.setColorPontuation(player.rating!.valuation)['icon'],
                            size: 15,
                            color: AppHelper.setColorPontuation(player.rating!.valuation)['color'],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                ButtonTextWidget(
                  text: buttonConfig['text'],
                  height: 30,
                  width: (dimensions.width * 0.3) - 10,
                  textColor: AppColors.white,
                  backgroundColor: buttonConfig['color'],
                  disabled: buttonConfig['disabled'],
                  action: () => setPlayerPosition(player.id),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}