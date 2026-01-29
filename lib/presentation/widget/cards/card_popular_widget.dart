import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/utils/img_utils.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/event_service.dart';

class CardPopularWidget extends StatelessWidget {
  final EventModel event;  
  const CardPopularWidget({
    super.key, 
    required this.event,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: ImgUtils.getEventImg(event.photo),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                AppColors.dark_500.withAlpha(50),
                AppColors.dark_500,
              ],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              Text(
                event.title!,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        AppIcones.star_solid,
                        color: AppColors.yellow_500,
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          "12.2",//EventService().getEventAvaliation(event.avaliations).toStringAsFixed(1),
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: AppColors.white
                          ),
                        ),
                      ),
                      Text(
                        "(${event.avaliations!.length.toString()} avaliações)",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.white
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => print('heart'), 
                    icon: const Icon(
                      Icons.bookmark,
                      color: AppColors.white,
                      size: 30,
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