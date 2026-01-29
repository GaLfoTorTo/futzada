import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/utils/img_utils.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/presentation/widget/indicators/indicator_avaliacao_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_live_widget.dart';

class CardEventSearchWidget extends StatelessWidget {
  final EventModel event;

  const CardEventSearchWidget({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR CONTROLLER DE EVENTO 
    EventController eventController = EventController.instance;
    //DEFINIR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;
    //RESGATAR AVALIAÇÃO DO EVENTO
    double avaliation = 12.2;//eventController.eventService.getEventAvaliation(event.avaliations);
    //RESGATAR DATA DO EVENTO
    String eventDate = event.date.toString().replaceAll('[', '').replaceAll(']', '').toString();

    return InkWell(
      onTap: () => {
        //DEFINIR EVENTO ATUAL NO CONTROLLER
        eventController.setSelectedEvent(event),
        //NAVEGAR PARA PAGINA DO EVENTO
        Get.toNamed(
          "/event/geral",
          arguments: {
            'event': event,
          }
        )
      },
      child: Card(
        child: Container(
          width: dimensions.width,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: ImgUtils.getEventImg(event.photo),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  SizedBox(
                    width: dimensions.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            SizedBox(
                              width: dimensions.width * 0.4,
                              child: Text(
                                event.title!, 
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                            if(event.visibility!.name != "Public")...[
                              const Icon(
                                Icons.lock_rounded,
                                color: AppColors.grey_300,
                              )
                            ]
                          ],
                        ),
                        if(event.visibility!.name == "Public")...[
                          Row(
                            spacing: 10,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  const Icon(
                                    AppIcones.calendar_solid,
                                    color: AppColors.grey_300,
                                    size: 20
                                  ),
                                  Text(
                                    eventDate,
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: AppColors.grey_500
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]
                              ),
                              if(gameController.inProgressGames.isNotEmpty)...[
                                const IndicatorLiveWidget(
                                  size: 15,
                                  color: AppColors.red_300,
                                ),
                              ]
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 5,
                            children: [
                              const Icon(
                                Icons.timer,
                                color: AppColors.grey_300,
                                size: 20
                              ),
                              Text(
                                "${event.startTime} as ${event.endTime}",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: AppColors.grey_500
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              IndicatorAvaliacaoWidget(
                                avaliation: avaliation,
                                width: 100,
                                starSize: 15,
                              ),
                              Text(
                                avaliation.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ]else...[
                          ...List.generate(3, (index) {
                            return Container(
                              width: 200,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.grey_300.withAlpha(100),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          })
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}