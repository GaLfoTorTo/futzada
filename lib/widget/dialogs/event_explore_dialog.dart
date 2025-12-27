import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/utils/img_utils.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/helpers/date_helper.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/indicators/indicator_avaliacao_widget.dart';

class EventExploreDialog extends StatelessWidget {
  final List<EventModel> events;
  const EventExploreDialog({
    super.key,
    required this.events
  });

  @override
  Widget build(BuildContext context) {
    //DEFINIR CONTROLLER DE EVENTO 
    EventController eventController = EventController.instance;
    //RESGATAR AVALIAÇÃO DO EVENTO
    double avaliation = eventController.getAvaliations(events[0].avaliations);
    //RESGATAR DATA DO EVENTO
    String eventDate = DateHelper.getEventDate(events[0]);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
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
                        image: ImgUtils.getEventImg(events[0]),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        events[0].title!, 
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 5,
                        children: [
                          const Icon(
                            AppIcones.calendar_solid,
                            color: AppColors.gray_300,
                            size: 20
                          ),
                          Text(
                            eventDate,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.gray_500
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 5,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: AppColors.gray_300,
                            size: 20
                          ),
                          Text(
                            "${events[0].startTime} as ${events[0].endTime}",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.gray_500
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
                            "${avaliation.toStringAsFixed(1)}", 
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
              
                ],
              ),
              IconButton(
                onPressed: () => Get.back(), 
                icon: Icon(Icons.close),
              ),
            ],
          ),
          const Divider(color: AppColors.gray_300),
        ],
      ),
    );
  }
}