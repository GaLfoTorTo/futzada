import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/others/lineup_widget.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/widget/others/players_lineup_widget.dart';

class GameEscalationPage extends StatefulWidget {
  const GameEscalationPage({super.key});

  @override
  State<GameEscalationPage> createState() => _GameEscalationPageState();
}

class _GameEscalationPageState extends State<GameEscalationPage> {
  //RESGATAR CONTROLLER DE PARTIDAS
  GameController gameController = GameController.instance;
  //CONTROLADOR DE VISUALIZAÇÃO DE ESCALAÇÃO
  bool escalationView = true;
  
  @override
  Widget build(BuildContext context) {
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
          spacing: 10,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                LineupWidget(category: gameController.currentGameConfig!.category!),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 400,
                      child: PlayersLineupWidget(players: teamA.players, command: "Home")
                    ),
                    SizedBox(
                      height: 400,
                      child: PlayersLineupWidget(players: teamB.players, command: "Away")
                    )
                  ],
                )
              ],
            ),
            const Divider(color: AppColors.gray_300),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: dimensions.width * 0.4,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.blue_300, width: 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      teamA.name ?? 'Time A',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.blue_300
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: dimensions.width * 0.4,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.red_300, width: 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      teamB.name ?? 'Time B',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.red_300
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
    );
  }
}