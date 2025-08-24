import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';

class CardDayEventWidget extends StatelessWidget {
  final EventModel event;
  
  const CardDayEventWidget({
    super.key, 
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;
    //RESGATAR IMAGENS DOS USUARIOS
    List<String> userImages = event.participants!.take(3).map((item){
      return item.user.photo ?? AppImages.userDefault;
    }).toList();
    //RESGATAR DATA DO EVENTO
    String eventDate = event.date != null 
      ? event.date! 
      : event.daysWeek!.replaceAll('[', '').replaceAll(']', '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Dia de Jogo",
            style: Theme.of(context).textTheme.titleMedium
          ),
        ),
        Container(
          width: dimensions.width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.green_300,
            image: DecorationImage(
              image: AssetImage(AppImages.gramado) as ImageProvider,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.green_300.withAlpha(220), 
                BlendMode.srcATop,
              )
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark_500.withAlpha(50),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: Offset(2, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.white, 
                        width: 2
                      ),
                      color: AppColors.green_300,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${event.title}",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.white
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(
                              AppIcones.calendar_solid,
                              color: AppColors.white,
                              size: 15,
                            ),
                            Text(
                              eventDate,
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: AppColors.white
                              )
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: AppColors.white,
                              size: 15,
                            ),
                            Text(
                              "Horário: ${event.startTime} - ${event.endTime}",
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: AppColors.white
                              )
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.white,
                              size: 15,
                            ),
                            Text(
                              "${event.address?.city}/${event.address?.country}",
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: AppColors.white
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  /* if(gameController.inProgressGames.isNotEmpty)...[
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: AppColors.red_300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const IndicatorLiveWidget(
                        size: 15,
                        color: AppColors.white,
                      ),
                    ),
                  ] */
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ImgGroupCircularWidget(
                    width: 40, 
                    height: 40,
                    borderColor: AppColors.white,
                    images: userImages,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}