import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/utils/img_utils.dart';
import 'package:futzada/core/utils/map_utils.dart';

class CardToYouWidget extends StatelessWidget {
  final EventModel event;
  const CardToYouWidget({
    super.key, 
    required this.event
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR POSIÇÕES DO USUARIO
    Rxn<LatLng> userLatLog = Get.find(tag: 'userLatLog');
    //RESGATAR POSIÇÕES DO MARKER
    final eventLatLon = LatLng(event.address!.latitude!, event.address!.longitude!);
    //RESGATAR DISTANCIA ATE O LOCAL
    double distance = MapUtils.getDistance(userLatLog.value!, eventLatLon);
          
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: ImgUtils.getEventImg(event.photo),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                AppColors.dark_500.withAlpha(50),
                AppColors.dark_500,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  event.title!,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AppColors.white
                  )
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "${distance.floor()} Km",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: AppColors.white
                      )
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