import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/images/img_group_circle_widget.dart';

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
    //RESGATAR CONTROLLER DE PARTIDAS
    GameController gameController = GameController.instance;
    //RESGATAR DATA DO EVENTO
    final now = DateTime.now();
    final day = now.day.toString();
    final month = DateFormat('MMM').format(now).toUpperCase().toString();
    //RESGATAR IMAGENS DOS USUARIOS
    List<String> userImages = event.participants!.take(3).map((user) => user.photo ?? AppImages.userDefault).toList();
    //VERIFICAR SE TEM PARTIDA EM ANDAMENTO
    bool hasGame = gameController.inProgressGames.any((gameEvent) => gameEvent?.id == event.id);
            
    return Card(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.green_300,
          image: DecorationImage(
            image: const AssetImage(AppImages.cardFootball) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.green_300.withAlpha(220), 
              BlendMode.srcATop,
            )
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: dimensions.width * 0.6,
                      child: Text(
                        "${event.title}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                if(hasGame)...[
                  Container(
                    width: 30,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.red_300,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Icon(
                      Icons.sensors,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        month,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: AppColors.dark_300
                        )
                      ),
                      Text(
                        day,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.dark_300
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        const Icon(
                          Icons.timer,
                          color: AppColors.white,
                          size: 25,
                        ),
                        Text(
                          "${event.startTime!} - ${event.endTime!}",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.white
                          )
                        ),
                      ]
                    ),
                    Row(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.white,
                          size: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${event.address?.street}",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: AppColors.white
                              )
                            ),
                            Text(
                              "${event.address?.city}/${event.address?.state}",
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: AppColors.white
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ImgGroupCircularWidget(
                  width: 40, 
                  height: 40,
                  borderColor: AppColors.white,
                  images: userImages,
                ),
                IconButton(
                  onPressed: () => print('share'), 
                  icon: const Icon(
                    Icons.share,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () => print('heart'), 
                  icon: const Icon(
                    AppIcones.heart_solid,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                ButtonTextWidget(
                  action: () => Get.toNamed('/games/day', arguments: {'event': event}),
                  width: 80,
                  height: 30,
                  text: "Entrar",
                  backgroundColor: AppColors.white.withAlpha(100),
                  textColor: AppColors.white,
                  borderRadius: 50,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}