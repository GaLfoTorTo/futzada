import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/widget/others/podium_widget.dart';

class CardPodiumWidget extends StatelessWidget {
  final List<ParticipantModel> rank;
  final String title;
  const CardPodiumWidget({
    super.key,
    required this.rank,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Container(
      width: dimensions.width,
      height: dimensions.height * 0.40,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: const AssetImage(AppImages.gramado) as ImageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.green_300.withAlpha(220), 
            BlendMode.srcATop,
          )
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if(rank.isNotEmpty)...[  
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.blue_500
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(3, (index) {
                final order = [1, 0, 2];
                final position = order[index];
                
                if (position < rank.length) {
                  return PodiumWidget(
                    participant: rank[position],
                    position: position + 1,
                  );
                }
                return SizedBox.shrink();
              }),
            ),
          ]else...[
            Column(
              spacing: 20,
              children: [
                Text(
                  "Nenhum ranking definido!",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.blue_500
                  ),
                ),
                const Icon(
                  AppIcones.medal_solid,
                  color: AppColors.blue_500,
                  size: 100,
                ),
                Text(
                  "Os rankings serão definidos a partir das partidas disputadas na pelada.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.blue_500
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}