import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/presentation/widget/charts/chart_level.dart';

class CardLevelWidget extends StatelessWidget {
  final UserModel  user;

  const CardLevelWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    //RESGATAR TEMA PERSONALIZADO PARA MODALIDADE PRINCIPAL DO USUARIO
    final modalityInfo = ModalityHelper.getEventModalityColor(user.config!.mainModality!.name);
    final modalityColor = modalityInfo['color'];
    final modalityTextColor = modalityInfo['textColor'];
    final modalityImage = modalityInfo['image'];

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.green_300,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(modalityImage) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              modalityColor.withAlpha(230), 
              BlendMode.srcATop,
            )
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          spacing: 20,
          children: [
            SizedBox(
              width: dimensions.width * 0.25,
              height: 150,
              child: ChartLevel(
                value: 75.0,
                color: modalityTextColor,
                level: 12
              ),
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nível Atual',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: modalityTextColor
                    ),
                  ),
                  Text(
                    'Varzea II',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: modalityTextColor
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'XP progresso',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: modalityTextColor
                        ),
                      ),
                      Text(
                        '75%',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: modalityTextColor
                        ),
                      ),
                    ],
                  ),
                  LinearProgressIndicator(
                    color: modalityTextColor,
                    backgroundColor: AppColors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 10,
                    value: 0.75,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}