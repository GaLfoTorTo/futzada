import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/indicators/stats_game_widget.dart';
import 'package:get/get.dart';

class GameStatisticsPage extends StatefulWidget {
  const GameStatisticsPage({super.key});

  @override
  State<GameStatisticsPage> createState() => _GameStatisticsPageState();
}

class _GameStatisticsPageState extends State<GameStatisticsPage> {
  //RESGATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;

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
        padding: const EdgeInsets.all(10),
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
          return Column(
            spacing: 15,
            children: [
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
              StatsGameWidget(
                title: "Posse de Bola", 
                teamAValue: gameController.teamAPossesion.value, 
                teamBValue: gameController.teamBPossesion.value
              ),
              StatsGameWidget(
                title: "Chutes", 
                teamAValue: gameController.teamAShots.value, 
                teamBValue: gameController.teamBShots.value
              ),
              StatsGameWidget(
                title: "Chutes a Gol", 
                teamAValue: gameController.teamAShotsGoal.value, 
                teamBValue: gameController.teamBShotsGoal.value
              ),
              StatsGameWidget(
                title: "Passes", 
                teamAValue: gameController.teamAPasses.value, 
                teamBValue: gameController.teamBPasses.value
              ),
              StatsGameWidget(
                title: "Escanteios", 
                teamAValue: gameController.teamACorners.value, 
                teamBValue: gameController.teamBCorners.value
              ),
              StatsGameWidget(
                title: "Faltas", 
                teamAValue: gameController.teamAFouls.value, 
                teamBValue: gameController.teamBFouls.value
              ),
              StatsGameWidget(
                title: "Defesas", 
                teamAValue: gameController.teamADefense.value, 
                teamBValue: gameController.teamBDefense.value
              ),
            ]
          );
        })
      )
    );
  }
}