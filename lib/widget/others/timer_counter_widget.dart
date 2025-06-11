import 'package:futzada/models/game_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/services/timer_service.dart';
import 'package:futzada/theme/app_colors.dart';

class TimerCounterWidget extends StatelessWidget {
   final GameModel game;

  const TimerCounterWidget({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR SERVIÇO DE CRONOMETRO DO GET
    final timerService = TimerService.instance;

    //FUNÇÃO PARA RETORNAR TEXTO DE MINUTOS PASSADOS OU INICIADOS
    String timeElapsedText(minutesElapsed){
      //VERIFICAR MINUTOS RESTANTES
      if (minutesElapsed >= 0) {
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
      //OBTER O TEMPO DECORRIDO DO CONTROLLER OU SERVICE
      final minutesElapsed = timerService.elapsedMinutesStream(game.id);

      return Text(
        timeElapsedText(minutesElapsed),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: AppColors.gray_300,
        ),
      );
    });
  }
}