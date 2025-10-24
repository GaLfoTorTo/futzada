import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
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
    final now = DateTime.now();
    final day = now.day.toString();
    final month = DateFormat('MMM').format(now).toUpperCase().toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dia de Jogo",
                style: Theme.of(context).textTheme.titleSmall
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.dark_500,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Brasilia/DF",
                    style: Theme.of(context).textTheme.titleSmall
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: dimensions.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.green_300,
            image: DecorationImage(
              image: const AssetImage(AppImages.gramado) as ImageProvider,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(gameController.inProgressGames.isNotEmpty)...[
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.red_300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const IndicatorLiveWidget(
                    size: 15,
                    color: AppColors.white,
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: dimensions.width * 0.7,
                    child: Text(
                      "${event.title}",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
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
                          style: Theme.of(context).textTheme.labelMedium!
                        ),
                        Text(
                          day,
                          style: Theme.of(context).textTheme.titleSmall!
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: dimensions.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.timer,
                                    color: AppColors.white,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      "${event.startTime} - ${event.endTime}",
                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        color: AppColors.white
                                      )
                                    ),
                                  ),
                                ]
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: dimensions.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: AppColors.white,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      "${event.address?.street} - ${event.address?.city}",
                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        color: AppColors.white
                                      )
                                    ),
                                  ),
                                ]
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                    action: () => print('participar'),
                    width: 80,
                    height: 30,
                    text: "Juntar-se",
                    backgroundColor: AppColors.white.withAlpha(100),
                    textColor: AppColors.white,
                    borderRadius: 50,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}