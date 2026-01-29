import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/utils/img_utils.dart';
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
    
    return Container(
      width: dimensions.width - 10,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.green_300,
        image: DecorationImage(
          image: const AssetImage(AppImages.cardFootball) as ImageProvider,
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
                        color: AppColors.white,
                        fontSize: 35,
                      ),
                      children: [
                        TextSpan(
                          text: "do dia",
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: AppColors.white,
                            fontSize: 30,
                          ),
                        ),
                      ]
                    ),
                  ),
                  Text(
                    "Melhor atuação no dia",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white,
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
                          color: AppColors.white,
                        ),
                        Text(
                          "${item.value['value']}",
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: AppColors.white,
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
              backgroundImage: ImgUtils.getUserImg(player.photo),
            ),
          ),
        ],
      ),
    );
  }
}