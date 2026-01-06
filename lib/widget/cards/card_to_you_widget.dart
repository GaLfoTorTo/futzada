import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/utils/img_utils.dart';
import 'package:futzada/utils/map_utils.dart';

class CardToYouWidget extends StatelessWidget {
  final List<EventModel> events;
  final PageController pageController;
  
  const CardToYouWidget({
    super.key, 
    required this.events,
    required this.pageController
  });

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 450,
      child: PageView(
        controller: pageController,
        children: events.map((event) {
          //RESGATAR POSIÇÕES DO USUARIO
          Rxn<LatLng> userLatLog = Get.find(tag: 'userLatLog');
          //RESGATAR POSIÇÕES DO MARKER
          final eventLatLon = LatLng(event.address!.latitude!, event.address!.longitude!);
          //RESGATAR DISTANCIA ATE O LOCAL
          double distance = MapUtils.getDistance(userLatLog.value!, eventLatLon);
          
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark_500.withAlpha(50),
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: const Offset(2, 5),
                ),
              ],
              image: DecorationImage(
                image: ImgUtils.getEventImg(event.photo),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.dark_500.withAlpha(50),
                    AppColors.dark_500,
                  ],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                )
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
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
          );
        }).toList(),
      ),
    );
  }
}