import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/services/timer_service.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:get/get.dart';

class StopWatchDialog extends StatelessWidget {
  final GameModel game;

  const StopWatchDialog({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE PARTIDAS E SERVIÇO DE CRONOMETRO DO GET
    final timerService = Get.find<TimerService>();
    final gameController = Get.find<GameController>();
    //RESGATAR DURAÇÃO DA PARTIDA
    final duration = Duration(minutes: game.duration ?? 10);
 
    return Dialog(
      backgroundColor: AppColors.green_300,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: AppColors.dark_300,
      child: Obx((){
        //RESGATAR TEMPO DA PARTIDA
        final currentTime = gameController.currentTime;
        final isRunning = timerService.isRunning(game.id);
        print(isRunning);
        //SEPARAR TEMPO RECEBIDO POR ":"
        final parts = currentTime.split(':');
        //RESGATAR MINUTOS E SEGUNDOS
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;
        //CALCULAR SEGUNDOS DECORRIDO DA PARTIDA
        final totalElapsedSeconds = minutes * 60 + seconds;
        final totalDurationSeconds = duration.inSeconds;
        //CALCULAR PROGRESSO DECORRIDO DE PARTIDA
        final progress = totalDurationSeconds > 0 
          ? totalElapsedSeconds / totalDurationSeconds
                        : 0.0;
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.green_500.withAlpha(100),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => timerService.resetStopwatch(game.id),
                      icon: const Icon(
                        Icons.restart_alt_rounded,
                        color: AppColors.blue_500,
                        size: 40,
                      ),
                      tooltip: "Reiniciar",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: IconButton(
                        onPressed: () => isRunning 
                            ? gameController.pauseGame(game)
                            : gameController.startGame(game),
                        alignment: Alignment.center,
                        icon: Icon(
                          isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: AppColors.blue_500,
                          size: 70,
                        ),
                        tooltip: isRunning ? "Pausar" : "Iniciar",
                      ),
                    ),
                    IconButton(
                      onPressed: () => timerService.stopStopwatch(game.id),
                      icon: const Icon(
                        Icons.stop_rounded,
                        color: AppColors.blue_500,
                        size: 50,
                      ),
                      tooltip: "Parar",
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$currentTime",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.blue_500
                      ),
                    ),
                    Text(
                      "${duration.inMinutes}:00",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.blue_500
                      ),
                    )
                  ],
                )
              ),
              //BARRA DE PROGRESSO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.green_500,
                  color: AppColors.blue_500,
                  borderRadius: BorderRadius.circular(5),
                  minHeight: 5,
                ),
              ),
            ],
          ),
        );
      })
    );
  }
}