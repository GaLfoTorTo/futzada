import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class IndicatorAvaliacaoWidget extends StatelessWidget {
  final double estrelas;
  const IndicatorAvaliacaoWidget({
    super.key,
    required this.estrelas
  });

  @override
  Widget build(BuildContext context) {
    //DEFINIR COR DA ESTRELA
    Color numEstrelas(int i){
      if(estrelas >= i){
        return AppColors.yellow_500;
      }
      return AppColors.gray_300;
    }

    return SizedBox(
      width: 100,
      child: Row(
        children: [
          for(var i = 1; i <= 5; i ++)
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Icon(
                    AppIcones.star_solid,
                    size: 20,
                    color: numEstrelas(i),
                  ),
                ),
                if(estrelas + 1 > i && estrelas.toInt() != 0)
                  const Icon(
                    AppIcones.star_half_solid,
                    size: 20,
                    color: AppColors.yellow_500,
                  ),
              ]
            ),
        ],
      ),
    );
  }
}