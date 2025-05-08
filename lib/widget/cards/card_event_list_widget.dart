import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class CardEventListWidget extends StatelessWidget {
  final double? height;
  final dynamic event;

  const CardEventListWidget({
    super.key,
    this.height = 250,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => {
        print(("/event/geral/${event['uuid']}"))
        //Get.toNamed("/event/geral/${event['uuid']}")
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
                  /* image: item['photo'] != null 
                    ? CachedNetworkImageProvider(item['photo']) 
                    : AssetImage(item['photo']) as ImageProvider, */
                    image: AssetImage(event['photo']) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                event['title'],
                style: const TextStyle(
                  color: AppColors.dark_500,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Data: ${event['date']}",
                    style: const TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    event['location'],
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
                "Horário: ${event['startTime']} - ${event['endTime']}",
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