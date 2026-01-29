import 'package:futzada/core/enum/enums.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

class TimerCounterWidget extends StatelessWidget {
  final GameModel game;
  final Color? color;

  const TimerCounterWidget({
    super.key,
    required this.game,
    this.color = AppColors.grey_300
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
      } else if(gameController.currentGame.status == GameStatus.Completed || gameController.currentGame.status == GameStatus.Cancelled){
        //EXIBIÇÃO DE MENSAGEM DE FINALIZAÇÃO
        return "Finalizado";
      } else {
        //EXIBIÇÃO DURANTE O DECORRER DA PARTIDA
        return "$minutesElapsed'";
      }
    }

    return Obx(() {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(100),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: color!,
            width: 2            
          )
        ),
        child: Text(
          timeElapsedText(gameController.minutesElapsed.value),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: color,
          ),
        ),
      );
    });
  }
}