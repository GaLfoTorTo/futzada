import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/data/models/event_model.dart';

class CardTasksWidget extends StatelessWidget {
  final EventModel event;
  
  const CardTasksWidget({
    super.key, 
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
            
    return Card(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          /* color: AppColors.green_300,
          image: DecorationImage(
            image: const AssetImage(AppImages.cardFootball) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.green_300.withAlpha(200), 
              BlendMode.srcATop,
            )
          ), */
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }
}