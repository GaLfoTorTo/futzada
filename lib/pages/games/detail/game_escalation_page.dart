import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/dialogs/escalation_dialog.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:get/get.dart';

class GameEscalationPage extends StatefulWidget {
  const GameEscalationPage({super.key});

  @override
  State<GameEscalationPage> createState() => _GameEscalationPageState();
}

class _GameEscalationPageState extends State<GameEscalationPage> {
  //RESGATAR CONTROLLER DE PARTIDAS
  GameController gameController = GameController.instance;
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: dimensions.width,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
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
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ButtonTextWidget(
                    width: dimensions.width,
                    height: 25,
                    backgroundColor: AppColors.green_300,
                    textSize: 12,
                    icon: AppIcones.escalacao_solid,
                    textColor: AppColors.blue_500,
                    iconSize: 20,
                    action: () => Get.bottomSheet(
                      const EscalationDialog(
                        team: true,
                      ),
                      isScrollControlled: true
                    )
                  ),
                ),
                const Divider(color: AppColors.gray_300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx((){
                      return Column(
                        children: List.generate(gameController.currentGame.teams!.first.players.length, (item){
                          //DEFINIR NOME, USER NAME, FOTO PADRÃO PARA OCUPANTE DO TIME
                          String name = "Jogador";
                          String userName = "jogador";
                          dynamic photo;
                          //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                          if (item < gameController.teamAlength.value &&
                              item < gameController.teamA.players.length) {
                            //RESGATAR PARTICIPANT NA EQUIPE 
                            final participant = gameController.teamA.players[item];
                            //RESGATAR NOME, USER NAME E FOTO DO PARTICIPANTE
                            name = "${participant.user.firstName} ${participant.user.lastName}";
                            userName = participant.user.userName!;
                            photo = participant.user.photo;
                          }

                          return Container(
                            width: dimensions.width * 0.45,
                            decoration: BoxDecoration(
                              color: name == 'Jogador' ? AppColors.gray_300.withAlpha(50) : AppColors.white,
                              border: const Border(
                                bottom: BorderSide(width: 1, color: AppColors.gray_300)
                              )
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ImgCircularWidget(
                                  width: 40, 
                                  height: 40,
                                  borderColor: AppColors.blue_300,
                                  image: photo,
                                ),
                                Container(
                                  width: dimensions.width * 0.3,
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "@$userName",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: AppColors.gray_300
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ),
                          );
                        })
                      );
                    }),
                    Obx((){
                      return Column(
                        children: List.generate(gameController.currentGame.teams!.last.players.length, (item){
                          //DEFINIR NOME, USER NAME, FOTO PADRÃO PARA OCUPANTE DO TIME
                          String name = "Jogador";
                          String userName = "jogador";
                          dynamic photo;
                          //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                          if (item < gameController.teamBlength.value &&
                              item < gameController.teamB.players.length) {
                            //RESGATAR PARTICIPANT NA EQUIPE 
                            final participant = gameController.teamB.players[item];
                            //RESGATAR NOME, USER NAME E FOTO DO PARTICIPANTE
                            name = "${participant.user.firstName} ${participant.user.lastName}";
                            userName = participant.user.userName!;
                            photo = participant.user.photo;
                          }

                          return Container(
                            width: dimensions.width * 0.45,
                            decoration: BoxDecoration(
                              color: name == 'Jogador' ? AppColors.gray_300.withAlpha(50) : AppColors.white,
                              border: const Border(
                                bottom: BorderSide(width: 1, color: AppColors.gray_300)
                              )
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: dimensions.width * 0.3,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        name,
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "@$userName",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: AppColors.gray_300
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                ImgCircularWidget(
                                  width: 40, 
                                  height: 40,
                                  borderColor: AppColors.red_300,
                                  image: photo,
                                ),
                              ]
                            ),
                          );
                        })
                      );
                    }),
                  ],
                )
              ]
            )
          )
        ]
      )
    );
  }
}