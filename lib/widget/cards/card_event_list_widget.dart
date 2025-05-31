import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:intl/intl.dart';

class CardEventListWidget extends StatelessWidget {
  final double? height;
  final EventModel event;

  const CardEventListWidget({
    super.key,
    this.height = 250,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //VERIFICAR SE O EVENTO ESTA ACONTECENDO AGORA
    bool isLive = AppHelper.verifyInLive(event);

    return InkWell(
      onTap: () => {
        Get.toNamed(
          "/event/geral",
          arguments: event
        )
      },
      child: Container(
        width: dimensions.width,
        height: height,
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
                  Text(
                    event.title!,
                    style: const TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if(isLive)...[
                    const IndicatorLiveWidget(
                      size: 15,
                      color: AppColors.red_300,
                    ),
                  ]
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Data: ${event.date}",
                    style: const TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${event.city}/${event.state}",
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
              child: Text(
                "Horário: ${event.startTime} - ${event.endTime}",
                style: const TextStyle(
                  color: AppColors.dark_500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}