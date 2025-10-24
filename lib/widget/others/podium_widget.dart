import 'package:flutter/material.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/badges/position_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';

class PodiumWidget extends StatelessWidget {
  final ParticipantModel participant;
  final int position;
  const PodiumWidget({
    super.key,
    required this.participant,
    required this.position
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    Map<String, dynamic> setPosition(position){
      switch(position){
        case 1:
          return {
            "height": 250.0,
            "color": AppColors.yellow_500,
          };
        case 2:
          return {
            "height": 210.0,
            "color": AppColors.gray_500,
          };
        case 3:
          return {
            "height": 210.0,
            "color": AppColors.brown_500,
          };
        default:
          return {
            "height": 100.0,
            "color": AppColors.green_500,
          };
      }
    }
    //DEFINIR POSIÇÃO DO PÓDIO
    var podiumPosition = setPosition(position);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Container(
            width: dimensions.width * 0.275,
            height: podiumPosition["height"],
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(position == 1)...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: Icon(
                      AppIcones.crown_solid, 
                      color: podiumPosition["color"],
                      size: 30,
                    ),
                  ),
                ],
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: 100,
                  child: Stack(
                    children: [
                      ImgCircularWidget(
                        height: 90,
                        width: 90,
                        image: participant.user.photo,
                        borderColor: podiumPosition['color']
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.dark_500.withAlpha(30),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              AppIcones.medal_solid, 
                              color: podiumPosition["color"],
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    PositionWidget(
                      position: participant.user.player!.mainPosition,
                      mainPosition: true,
                      width: 35,
                      height: 25,
                      textSide: 10,
                    ),
                    Text(
                      "${participant.user.firstName} ${participant.user.lastName}",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.dark_300,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "@${participant.user.userName}",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.gray_300,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.green_300,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                    "Jogos: 45",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ) 
          )
        ],
      ),
    );
  }
}