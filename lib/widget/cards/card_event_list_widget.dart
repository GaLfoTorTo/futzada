import 'package:futzada/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futzada/widget/indicators/indicator_avaliacao_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/controllers/event_controller.dart';

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
    double avaliation = eventController.getAvaliations(event.avaliations);
    //RESGATAR DATA DO EVENTO
    String eventDate = event.date != null 
      ? event.date! 
      : event.daysWeek!.replaceAll('[', '').replaceAll(']', '').toString();

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
      child: Container(
        width: dimensions.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(30),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: Offset(2, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: dimensions.width,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                image: DecorationImage(
                  image: event.photo != null 
                    ? CachedNetworkImageProvider(event.photo!) 
                    : const AssetImage(AppImages.gramado) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: dimensions.width * 0.4,
                    child: Text(
                      event.title!,
                      style: const TextStyle(
                        color: AppColors.dark_500,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    eventDate,
                    style: const TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${event.address!.city}/${event.address!.state}",
                    style: const TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text(
                    "Horário: ${event.startTime} - ${event.endTime}",
                    style: const TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 12,
                    ),
                  ),
                  if(gameController.inProgressGames.isNotEmpty)...[
                    const IndicatorLiveWidget(
                      size: 15,
                      color: AppColors.red_300,
                    ),
                  ]
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}