import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/core/helpers/date_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/avaliation_service.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/core/providers/game/game_schedule_provider.dart';
import 'package:futzada/presentation/widget/indicators/indicator_avaliacao_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_live_widget.dart';

class CardEventListWidget extends ConsumerWidget {
  final EventModel event;

  const CardEventListWidget({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR CONTROLLER DE EVENTO
    AvaliationService avaliationService = AvaliationService();
    //VERIFICAR SE HÁ PARTIDAS EM ANDAMENTO
    final hasInProgress = ref.watch(gameScheduleProvider.select((s) => s.inProgressGames.isNotEmpty));
    //RESGATAR AVALIAÇÃO DO EVENTO
    double avaliations = avaliationService.getRatingAvaliation(event.avaliations);
    //RESGATAR DATA DO EVENTO
    String eventDate = DateHelper.getEventDate(event.date!);

    return InkWell(
      onTap: () {
        //DEFINIR EVENTO ATUAL NO CONTROLLER E NAVEGAR
        EventController.instance.setSelectedEvent(event);
        context.go('/event/view');
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
                  image: ImgHelper.getEventImg(event.photo),
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
                              avaliation: avaliations,
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
                      if(hasInProgress)...[
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