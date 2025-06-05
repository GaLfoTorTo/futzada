import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:get/get.dart';

class EventGamesDialog extends StatelessWidget {
  const EventGamesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //CONTROLLER DE REGISTRO DA PELADA
    final controller = EventController.instace;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
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
                color: AppColors.gray_500,
              ),
              textAlign: TextAlign.center
            ),
          ),
          Divider(color: AppColors.gray_300),
          Obx(() {
            return Expanded(
              child: ListView(
                children: controller.nextGames.map((game) {
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dark_500.withAlpha(30),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: const Offset(2, 5),
                        ),
                      ],
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.gray_500,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      onPressed: (){
                        Get.back();
                        //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
                        Get.toNamed('/games/game_detail', arguments: {
                          'game': game,
                          'event': controller.event,
                        });
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
                                  image: controller.event.photo,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Partida #${game!.number}",
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
                                            color: AppColors.gray_300,
                                          ),
                                        ),
                                        Text(
                                          "${controller.event.address}",
                                          style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                                            color: AppColors.gray_500,
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
                                            color: AppColors.gray_300,
                                          ),
                                        ),
                                      Text(
                                        "Hoje: ${game.startTime} - ${game.endTime}",
                                        style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                                          color: AppColors.gray_500,
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
                    )
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