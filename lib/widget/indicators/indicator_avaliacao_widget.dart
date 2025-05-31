import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class IndicatorAvaliacaoWidget extends StatelessWidget {
  final double avaliation;
  final double? width;
  final double? starSize;

  const IndicatorAvaliacaoWidget({
    super.key,
    required this.avaliation,
     this.width = 100,
     this.starSize = 20
  });

  @override
  Widget build(BuildContext context) {
    //DEFINIR ICON DE ESTRELA APARTIR DA NOTA DE AVALIAÇÃO
    IconData getIconStar(int index) {
      if (avaliation >= index) {
        return AppIcones.star_solid;
      } else if (avaliation >= index - 0.5) {
        return AppIcones.star_half_solid;
      } else {
        return AppIcones.star_solid;
      }
    }

    return SizedBox(
      width: width,
      child: Row(
        children: [
          for(var i = 1; i <= 5; i ++)...[
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    AppIcones.star_solid,
                    size: starSize,
                    color: AppColors.gray_300,
                  ),
                ),
                if (avaliation >= i || (avaliation >= i - 0.5 && avaliation < i))...[
                  Positioned(
                    right: getIconStar(i) == AppIcones.star_half_solid ? 4 : 0,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        getIconStar(i),
                        size: starSize,
                        color: AppColors.yellow_500,
                      ),
                    ),
                  ),
                ]
              ]
            ),
          ]
        ],
      ),
    );
  }
}