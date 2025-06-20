import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/controllers/game_controller.dart';

class TimerCounterWidget extends StatelessWidget {
   final GameModel game;

  const TimerCounterWidget({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;

    //FUNÇÃO PARA RETORNAR TEXTO DE MINUTOS PASSADOS OU INICIADOS
    String timeElapsedText(minutesElapsed){
      //VERIFICAR MINUTOS RESTANTES
      if (minutesElapsed >= gameController.currentGame.duration) {
        //EXIBIÇÃO QUANDO 
        return "Tempo Extra";
      } else if (DateTime.now().isBefore(game.startTime!)) {
        //EXIBIÇÃO ANTERIOR AO INICIO DA PARTIDA
        return "Aguardando Inicio";
      } else {
        //EXIBIÇÃO DURANTE O DECORRER DA PARTIDA
        return "$minutesElapsed'";
      }
    }

    return Obx(() {
      return Text(
        timeElapsedText(gameController.minutesElapsed.value),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: AppColors.gray_300,
        ),
      );
    });
  }
}