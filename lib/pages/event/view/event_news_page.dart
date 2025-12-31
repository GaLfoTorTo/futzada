import 'package:flutter/material.dart';
import 'package:futzada/models/news_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/utils/img_utils.dart';
import 'package:futzada/utils/user_utils.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class EventNewsPage extends StatelessWidget {
  const EventNewsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DO EVENTO
    EventController eventController = EventController.instance;
    //ESTADO - EVENTO
    List<NewsModel>? news = eventController.event.news;

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            Text(
              "Notícias",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.blue_500
              ),
            ),
            Text(
              "As notícias são os registros de eventos e acontecimentos da referentes a pelada. Alteração de horarios e locais, adição ou remoção de participantes, alteração de regras, todas as informações são registras e podem ser visualizadas nesta aba.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if(news != null)...[
              Column(
                spacing: 10,
                children: news.map((event){
                  Map<String, dynamic> newsEvent = eventController.newsService.getEventNews(event.type);
                  return TimelineTile(
                    alignment: TimelineAlign.start,
                    lineXY: 0.2,
                    beforeLineStyle: const LineStyle(color: AppColors.gray_300, thickness: 1),
                    afterLineStyle: const LineStyle(color: AppColors.gray_300, thickness: 1),
                    indicatorStyle: IndicatorStyle(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      indicator: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: newsEvent['color'],
                          borderRadius: BorderRadius.circular(50)
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          newsEvent['icon'],
                          size: 25,
                          color: AppColors.white
                        ),
                      )
                    ),
                    endChild: Container(
                      width: dimensions.width,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.symmetric(vertical: BorderSide(color: newsEvent["color"], width: 8))
                      ),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                event.title,
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: AppColors.gray_300,
                                    size: 15,
                                  ),
                                  Text(
                                    DateFormat("HH:mm").format(event.createdAt!),
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      color: AppColors.gray_500
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Divider(),
                          Row(
                            spacing: 10,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: newsEvent['color'], width: 2)
                                ),
                                child: CircleAvatar(
                                  backgroundImage: event.participant != null 
                                    ? ImgUtils.getUserImg(event.participant!.user.photo)
                                    : ImgUtils.getEventImg(null),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    if(event.participant != null)...[
                                      Column(
                                        children: [
                                          Text(
                                            UserUtils.getFullName(event.participant!.user),
                                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            "@${event.participant!.user.userName}",
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                    Text(
                                      event.description,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  );
                }).toList(),
              )
            ]else...[
              Column(
                spacing: 50,
                children: [
                  Text(
                    "A pelada ainda não registrou nehuma notícia",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.gray_500
                    ),
                  ),
                  Icon(
                    Icons.history_rounded,
                    size: 200,
                    color: AppColors.gray_500.withAlpha(50),
                  )
                ],
              )
            ]
          ]
        ),
      ),
    );
  }
}