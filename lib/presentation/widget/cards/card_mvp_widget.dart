import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';

class CardMvpWidget extends StatelessWidget {
  const CardMvpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENTO
    EventModel event = Get.arguments['event'];
    //ESTADO - ITEMS EVENTO
    Color eventColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['color'];
    Color eventTextColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['textColor'];
    String eventImage = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['image'];
    UserModel player = event.participants!.first;
    //DEFINIR ESTATISTICAS
    Map<String, dynamic> stats = {
      'Gols': {
        'value': 12,
        'icon' : Icons.sports_soccer_rounded
      },
      'Assistencias': {
        'value': 7,
        'icon' : Icons.handshake_rounded
      },
    };
    
    return Card(
      child: Container(
        width: dimensions.width - 10,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: eventColor,
          image: DecorationImage(
            image: AssetImage(eventImage) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              eventColor.withAlpha(200), 
              BlendMode.srcATop,
            )
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(50),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Row(
          spacing: 40,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "MVP ",
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: AppColors.blue_500,
                          fontSize: 35,
                        ),
                        children: [
                          TextSpan(
                            text: "do dia",
                            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: AppColors.blue_500,
                              fontSize: 30,
                            ),
                          ),
                        ]
                      ),
                    ),
                    Text(
                      "Melhor atuação no dia",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.blue_500,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 20,
                  children: [
                    ...stats.entries.map((item){
                      return Column(
                        children: [
                          Icon(
                            item.value['icon'],
                            size: 40,
                            color: AppColors.blue_500,
                          ),
                          Text(
                            "${item.value['value']}",
                            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: AppColors.blue_500,
                            ),
                          )
                        ],
                      );
                    }).toList() 
                  ],
                )
              ],
            ),
            SizedBox(
              width: 120,
              height: 120,
              child: CircleAvatar(
                backgroundImage: ImgHelper.getUserImg(player.photo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}