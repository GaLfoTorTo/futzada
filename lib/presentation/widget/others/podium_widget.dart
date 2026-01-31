import 'package:flutter/material.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class PodiumWidget extends StatelessWidget {
  final UserModel user;
  final int rank;
  final Modality modality;
  const PodiumWidget({
    super.key,
    required this.user,
    required this.rank,
    required this.modality
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR POSIÇÃO PRINCIPAL DO JOGADOR APARTIR DA MODALIDADE
    final position = user.player!.mainPosition[modality];

    Map<String, dynamic> setPosition(rank){
      switch(rank){
        case 1:
          return {
            "height": 250.0,
            "color": AppColors.yellow_500,
          };
        case 2:
          return {
            "height": 210.0,
            "color": AppColors.grey_500,
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
    var podiumRank = setPosition(rank);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Container(
            width: dimensions.width * 0.275,
            height: podiumRank["height"],
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(rank == 1)...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: Icon(
                      AppIcones.crown_solid, 
                      color: podiumRank["color"],
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
                        image: user.photo,
                        borderColor: podiumRank['color']
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
                              color: podiumRank["color"],
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
                      position: position!,
                      mainPosition: true,
                      width: 35,
                      height: 25,
                      textSide: 10,
                    ),
                    Text(
                      UserHelper.getFullName(user),
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "@${user.userName}",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.grey_300,
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