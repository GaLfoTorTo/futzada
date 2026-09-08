import 'package:flutter/material.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:latlong2/latlong.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/img_helper.dart';
import 'package:esportly/core/helpers/map_helper.dart';

class CardToYouWidget extends StatelessWidget {
  final EventModel event;
  const CardToYouWidget({
    super.key, 
    required this.event
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR POSIÇÕES DO USUARIO
    final LatLng? userLatLon = sl.isRegistered<ValueNotifier<LatLng?>>(instanceName: 'userLatLog')
        ? sl<ValueNotifier<LatLng?>>(instanceName: 'userLatLog').value
        : null;
    //RESGATAR POSIÇÕES DO MARKER
    final eventLatLon = LatLng(event.address!.latitude!, event.address!.longitude!);
    //RESGATAR DISTANCIA ATE O LOCAL
    final double? distance = userLatLon != null ? MapHelper.getDistance(userLatLon, eventLatLon) : null;
          
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: ImgHelper.getEventImg(event),
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
                      distance != null ? "${distance.floor()} Km" : "— Km",
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