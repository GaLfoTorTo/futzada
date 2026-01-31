import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/others/lineup_widget.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/widget/others/players_lineup_widget.dart';

class GameEscalationPage extends StatelessWidget {
  const GameEscalationPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE PARTIDAS
    GameController gameController = GameController.instance;
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EQUIPES
    final teamA = gameController.currentGame.teams!.first;
    final teamB = gameController.currentGame.teams!.last;
    
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          color: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(30),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: Offset(2, 5),
            ),
          ],
        ),
        child: Obx((){
          if(!gameController.isGameReady.value){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "As Informações dos elencos serão exibidas assim que as equipes forem definidas pelos organizadores e colaboradores!",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const Icon(
                    AppIcones.escalacao_outline,
                    size: 50,
                  )
                ],
              ),
            );
          }
          return Column(
            spacing: 10,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  LineupWidget(category: gameController.currentGameConfig!.category),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 400,
                        child: PlayersLineupWidget(
                          category: gameController.currentGameConfig!.category,
                          players: teamA.players, 
                          command: "Home",
                          showPlayerName: true,
                        )
                      ),
                      SizedBox(
                        height: 400,
                        child: PlayersLineupWidget(
                          category: gameController.currentGameConfig!.category,
                          players: teamB.players, 
                          command: "Away",
                          showPlayerName: true,
                        )
                      )
                    ],
                  )
                ],
              ),
              const Divider(color: AppColors.grey_300),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(2, (i){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: dimensions.width * 0.4,
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: i == 0 ? AppColors.blue_300 : AppColors.red_300, width: 1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        i == 0 ? teamA.name ?? 'Time A' : teamB.name ?? 'Time B',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: i == 0 ? AppColors.blue_300 : AppColors.red_300
                        ),
                      ),
                    ),
                  );
                })
              ),
              Row(
                spacing: 2,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (i){
                  return Obx((){
                    //RESGATAR TAMANHO DAS EQUIPES (REATIVO)
                    final teamLength = i == 0 
                      ? gameController.teamAlength.value
                      : gameController.teamBlength.value;
          
                    return Expanded(
                      child: Column(
                        children: List.generate(gameController.currentGame.teams!.first.players.length, (item){
                          //DEFINIR NOME, USER NAME, FOTO PADRÃO PARA OCUPANTE DO TIME
                          String name = "Jogador";
                          String userName = "jogador";
                          dynamic photo;
                          //VERIFICAR SE TIME CONTEM A MESMA QUANTIDADE DE JOGADORES DEFINIDOS 
                          if (item < teamLength) {
                            //RESGATAR PARTICIPANT NA EQUIPE 
                            final user = i == 0 
                              ? gameController.teamA.players[item]
                              : gameController.teamB.players[item];
                            //RESGATAR NOME, USER NAME E FOTO DO PARTICIPANTE
                            name = UserHelper.getFullName(user);
                            userName = user.userName!;
                            photo = user.photo;
                          }

                          return Container(
                            width: dimensions.width * 0.45,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ?AppColors.dark_300 : AppColors.white,
                              border: const Border(
                                bottom: BorderSide(width: 1, color: AppColors.grey_300)
                              )
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if(i == 0)...[
                                  ImgCircularWidget(
                                    width: 40, 
                                    height: 40,
                                    borderColor: AppColors.blue_300,
                                    image: photo,
                                  ),
                                ],
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment: i == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          name,
                                          style: Theme.of(context).textTheme.titleSmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "@$userName",
                                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                            color: AppColors.grey_300
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if(i == 1)...[
                                  ImgCircularWidget(
                                    width: 40, 
                                    height: 40,
                                    borderColor: AppColors.red_300,
                                    image: photo,
                                  ),
                                ]
                              ]
                            ),
                          );
                        })
                      )
                    );
                  });
                }),
              )
            ]
          );
        })
      )
    );
  }
}