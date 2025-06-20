import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/overlays/stopwatch_overlay_widget.dart';

class StopWatchDialog extends StatefulWidget {
  const StopWatchDialog({
    super.key,
  });

  @override
  State<StopWatchDialog> createState() => _StopWatchDialogState();
}

class _StopWatchDialogState extends State<StopWatchDialog> {
  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE PARTIDAS E SERVIÇO DE CRONOMETRO DO GET
    final gameController = GameController.instance;

    //FUNÇÃO DE EXIBIÇÃO DE OVERLAY
    void showOverlay(function, action){
      //DELAY PARA EXIBIÇÃO DO OVERLAY
      Future.delayed(const Duration(milliseconds: 300), () async {
        await Get.showOverlay(
          asyncFunction: () async {
            //ESPERAR 5 SEGUNDOS ANTES DE EXECUTAR FUNÇÃO DE CRONOMETRO
            await Future.delayed(const Duration(seconds: 5));
            //FINALIZAR PARTIDA
            function();
          },
          loadingWidget:  Material(
            color: Colors.transparent,
            child: StopWatchOverlayWidget(
              seconds: 5,
              action: action
            ),
          ),
          opacity: 0.7,
          opacityColor: AppColors.dark_700,
        );
      });
    }

    //FUNÇÃO PARA EXIBIR OVERLAY ANTES DE INICIAR/CONTINUAR CRONOMETRO
    Future<bool> handleStopWatch(String action) async{
      switch (action) {
        case "pause":
          //PAUSAR PARTIDA
          gameController.pauseGame();  
          break;
        case "start":
          //FECHAR DIALOG
          Get.back();
          //EXIBIR OVERLAY
          showOverlay(gameController.startGame, action);
          break;
        case "stop":
          //FECHAR DIALOG
          Get.back();
          //EXIBIR OVERLAY
          showOverlay(gameController.stopGame, action);
          break;
        case "reset":
          //FECHAR DIALOG
          Get.back();
          //EXIBIR OVERLAY
          showOverlay(gameController.resetGame, action);
          break;
      }
      //VERIFICAR SE PARTIDA ESTA ROLANDO
      setState(() {});
      //FINALIZAR FUNÇÃO
      return true;
    }
    
    //FUNÇÃO PARA RESGATAR DURAÇÃO DA PARTIDA
    Duration getDuration(){
      //VERIFICAR DURAÇÃO DA PARTIDA FOI CONFIGURADA
      if(gameController.currentGameConfig != null && gameController.currentGameConfig!.duration != null ){
        return Duration(minutes: gameController.currentGameConfig!.duration!);
      }else if(gameController.currentGame.duration != null){
        return Duration(minutes: gameController.currentGame.duration!);
      }else{
        return Duration(minutes: 10);
      }
    }
    
    return Dialog(
      backgroundColor: AppColors.green_300,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: AppColors.dark_300,
      child: Obx((){
        //RESGATAR DURAÇÃO DA PARTIDA
        final duration = getDuration();
        final minutesDuration = duration.inMinutes.toString().padLeft(2, '0');;
        //RESGATAR TEMPO DA PARTIDA
        final currentTime = gameController.currentTime;
        final isRunning = gameController.timerService.isRunning(gameController.currentGame.id);
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
                      onPressed: () => handleStopWatch("reset"),
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
                        onPressed: () async{
                          handleStopWatch(isRunning ? "pausar" : "start",);
                        },
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
                      onPressed: () => handleStopWatch("stop"),
                      icon: const Icon(
                        Icons.stop_rounded,
                        color: AppColors.blue_500,
                        size: 50,
                      ),
                      tooltip: "Finalizar",
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
                      "$minutesDuration:00",
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