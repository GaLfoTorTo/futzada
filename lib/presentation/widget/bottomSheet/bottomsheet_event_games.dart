import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BottomSheetEventGames extends StatelessWidget {
  const BottomSheetEventGames({super.key});

  @override
  Widget build(BuildContext context) {
    //DEFINIR CONTROLLER DE EVENTO 
    EventController eventController = EventController.instance;
    //DEFINIR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;
    

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        children: [
          Row(
            children: [
              const BackButton(),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Text(
                  'Iniciar uma Partida',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Escolha a partida que vc deseja iniciar agora',
              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                color: AppColors.grey_500,
              ),
              textAlign: TextAlign.center
            ),
          ),
          const Divider(color: AppColors.grey_300),
          Obx(() {
            return Expanded(
              child: ListView(
                children: gameController.nextGames.map((game) {
                  //RESGATAR HORARIO DE INICIO E FIM DA PARTIDA
                  var gameTime = "${DateFormat.Hm().format(game!.startTime!)} - ${DateFormat.Hm().format(game.endTime!)}";
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ElevatedButton(
                      onPressed: (){
                        //DEFINIR PARTIDA ATUAL
                        gameController.setCurrentGame(game);
                        //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
                        Get.offAndToNamed('/games/overview');
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [ 
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ImgCircularWidget(
                                  width: 70, 
                                  height: 70,
                                  image: eventController.event.photo,
                                  element: "event",
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Partida #${game.number}",
                                    style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Icon(
                                            AppIcones.marker_solid,
                                            size: 20,
                                            color: AppColors.grey_300,
                                          ),
                                        ),
                                        Text(
                                          "${eventController.event.address!.state}",
                                          style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                                            color: AppColors.grey_500,
                                            overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            AppIcones.clock_solid,
                                            size: 15,
                                            color: AppColors.grey_300,
                                          ),
                                        ),
                                      Text(
                                        "Hoje: $gameTime",
                                        style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                                          color: AppColors.grey_500,
                                          overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}