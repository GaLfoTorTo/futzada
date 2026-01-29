import 'dart:convert';
import 'package:futzada/data/models/participant_model.dart';
import 'package:futzada/data/models/rating_model.dart';
import 'package:futzada/core/utils/user_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class CardPlayerMarketWidget extends StatelessWidget {
  final UserModel user;
  final String modality;
  const CardPlayerMarketWidget({
    super.key,
    required this.user,
    required this.modality,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE ESCALAÇÃO
    EscalationController escalationController = EscalationController.instance;
    //RESGATAR PARTICIPANTES
    ParticipantModel participant = user.participants!.firstWhere((p) => p.eventId == escalationController.event!.id);
    //RESGATAR JOGADOR
    PlayerModel player = user.player!;
    //RESGATAR RATING DO EVENTO
    RatingModel rating = UserUtils.getRating(player, escalationController.event!.id!);
    //RESGTAR JOGADOR COMO MAP
    Map<String, dynamic> playerMap = player.toMap();
    //RESGATAR POSIÇÕES DO JOGADOR
    List<String> playerPositions = player.positions[escalationController.event!.modality!.name]!;
    //REMOVER POSIÇÃO PRINCIPAL DO ARRAY
    playerPositions.remove(player.mainPosition[escalationController.event!.modality!.name]);

    //FUNÇÃO PARA DEFINIR TIPO DE BOTÃO
    Map<String, dynamic> setButtonBuy(PlayerModel player){
      //VERIFICAR SE USUARIO TEM FUTCOIN O SUFICIENTE PARA COMPRAR JOGADOR, SE NÃO RETORNAR BOTÃO DESABILITADO
      if(rating.price! > escalationController.managerPatrimony.value){
        return{
          'text':'Comprar',
          'color' : AppColors.grey_300,
          'disabled': true
        };
      }
      //VERIFICAR SE JOGADOR ESTA NA ESCALAÇÃO
      final isEscaled = escalationController.findPlayerEscalation(player.id!);
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
      escalationController.setPlayerEscalation(uuid);
      escalationController.update();
      //NAVEGAR DE VOLTA PARA ESCALAÇÃO
      Get.back();
    }

    //LISTA DE METRICAS DO CARD
    Map<String, dynamic> metrics = {
      'points':'Última pontuação', 
      'avarage': 'Media',
      'games':'jogos'
    };

    //DEFINIR CONFIGURAÇÕES DE BOTÃO DE COMPRA E VENDA DE JOGADOR
    var buttonConfig = setButtonBuy(player);

    return Card(
      child: Container(
        width: dimensions.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: dimensions.width * 0.6,
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImgCircularWidget(
                        height: 80,
                        width: 80,
                        image: user.photo,
                        borderColor: AppColors.grey_300,
                      ),
                      Expanded(
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              UserUtils.getFullName(user),
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis
                            ),
                            Text(
                              "@${user.userName}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: AppColors.grey_300
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, 
                            ),
                            Row(
                              spacing: 2,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                PositionWidget(
                                  position: user.player!.mainPosition[modality]!,
                                  mainPosition: true,
                                  width: 40,
                                  height: 25,
                                ),
                                ...playerPositions.asMap().entries.map((entry){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: PositionWidget(
                                      position: entry.value,
                                      mainPosition: false,
                                      width: 30,
                                      height: 20,
                                      textSide: 10,
                                    ),
                                  );
                                }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: dimensions.width * 0.6,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
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
                            decoration: BoxDecoration(
                              color: AppColors.grey_300.withAlpha(40),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Icon(
                      AppHelper.setStatusPlayer(participant.status)['icon'],
                      color: AppHelper.setStatusPlayer(participant.status)['color'],
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Fz\$",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_300),
                        ),
                        Text(
                          "${rating.price}",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "${rating.valuation}",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppHelper.setColorPontuation(rating.valuation)['color'], fontWeight: FontWeight.bold),
                              ),
                            ),
                            Icon(
                              AppHelper.setColorPontuation(rating.valuation)['icon'],
                              size: 15,
                              color: AppHelper.setColorPontuation(rating.valuation)['color'],
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
      ),
    );
  }
}