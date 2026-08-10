import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/indicators/stats_game_widget.dart';

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
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_500 : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(30),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: Offset(2, 5),
            ),
          ],
        ),
        child: ListenableBuilder(listenable: gameController, builder: (_, __){
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
                teamAValue: gameController.teamAPossesion, 
                teamBValue: gameController.teamBPossesion
              ),
              StatsGameWidget(
                title: "Chutes", 
                teamAValue: gameController.teamAShots, 
                teamBValue: gameController.teamBShots
              ),
              StatsGameWidget(
                title: "Chutes a Gol", 
                teamAValue: gameController.teamAShotsGoal, 
                teamBValue: gameController.teamBShotsGoal
              ),
              StatsGameWidget(
                title: "Passes", 
                teamAValue: gameController.teamAPasses, 
                teamBValue: gameController.teamBPasses
              ),
              StatsGameWidget(
                title: "Escanteios", 
                teamAValue: gameController.teamACorners, 
                teamBValue: gameController.teamBCorners
              ),
              StatsGameWidget(
                title: "Faltas", 
                teamAValue: gameController.teamAFouls, 
                teamBValue: gameController.teamBFouls
              ),
              StatsGameWidget(
                title: "Defesas", 
                teamAValue: gameController.teamADefense, 
                teamBValue: gameController.teamBDefense
              ),
            ]
          );
        })
      )
    );
  }
}