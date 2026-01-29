import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/utils/img_utils.dart';
import 'package:futzada/core/helpers/date_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/presentation/widget/indicators/indicator_avaliacao_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_live_widget.dart';

class CardEventListWidget extends StatelessWidget {
  final EventModel event;

  const CardEventListWidget({
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
    double avaliation = 4.2;//eventController.eventService.getEventAvaliation(event.avaliations);
    //RESGATAR DATA DO EVENTO
    String eventDate = DateHelper.getEventDate(event.date!);

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
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: dimensions.width,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                image: DecorationImage(
                  image: ImgUtils.getEventImg(event.photo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: dimensions.width * 0.4,
                        child: Text(
                          event.title!,
                          style: Theme.of(context).textTheme.titleSmall
                        ),
                      ),
                      SizedBox(
                        width: dimensions.width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IndicatorAvaliacaoWidget(
                              avaliation: avaliation,
                              width: dimensions.width / 4.5,
                              starSize: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "$eventDate - ${event.startTime} as ${event.endTime}",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      Text(
                        "${event.address!.city}/${event.address!.state}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      if(gameController.inProgressGames.isNotEmpty)...[
                        const IndicatorLiveWidget(
                          size: 15,
                          color: AppColors.red_300,
                        ),
                      ]
                    ]
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}