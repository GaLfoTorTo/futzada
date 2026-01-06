import 'package:flutter/material.dart';
import 'package:futzada/utils/img_utils.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';

class CardEventTodayWidget extends StatelessWidget {
  final List<EventModel> events;
  final PageController pageController;
  
  const CardEventTodayWidget({
    super.key, 
    required this.events,
    required this.pageController
  });

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    final width = events.length > 1 ? dimensions.width * 0.75 : dimensions.width - 20;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          children: events.map((event) {
            return Card(
              semanticContainer: true,
              child: Container(
                height: 250,
                width: width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: dimensions.width,
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: ImgUtils.getEventImg(event.photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      event.title!,
                      style: Theme.of(context).textTheme.titleSmall
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 5,
                              children: [
                                const Icon(
                                  Icons.timer,
                                  color: AppColors.gray_300,
                                ),
                                Text(
                                  "${event.startTime} - ${event.endTime}",
                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: AppColors.gray_500
                                  )
                                ),
                                Text(
                                  "Hoje",
                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: AppColors.red_300,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ]
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.gray_300,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${event.address?.street}",
                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                        color: AppColors.gray_500
                                      )
                                    ),
                                    Text(
                                      "${event.address?.city}/${event.address?.state}",
                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        color: AppColors.gray_300
                                      )
                                    ),
                                  ],
                                ),
                              ]
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}