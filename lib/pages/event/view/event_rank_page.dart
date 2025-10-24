import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/controllers/rank_controller.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/others/podium_widget.dart';
import 'package:futzada/widget/badges/position_widget.dart';

class EventRankPage extends StatelessWidget {
  const EventRankPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE RANK E EVENTO
    RankController rankController = RankController.instance;

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        child: Obx((){
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Rankings da Pelada",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Acompanhe de perto os jogadores e técnicos que se destacam na pelada com as melhores pontuações para cada tipo de estatística.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.gray_500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Rank por Jogos',
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
                        
                        if (position < rankController.topRanking.length) {
                          return PodiumWidget(
                            participant: rankController.topRanking[position]!,
                            position: position + 1,
                          );
                        }
                        return SizedBox.shrink();
                      }),
                    ),
                  ],
                ),
              ),
              Container(
                width: dimensions.width,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark_500.withAlpha(30),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(2, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 50),
                      width: dimensions.width * 0.10,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.gray_500,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    ...rankController.topRanking.skip(3).take(7).map((participant) {
                      int position = rankController.topRanking.indexOf(participant) + 1;
                      Map<String, dynamic> colocation = AppHelper.setRankColocation('down');
                      return Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: participant!.user.id == 1 ? AppColors.green_300 : AppColors.light.withAlpha(70),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: Row(
                          children: [
                            Icon(
                              colocation['icon'],
                              color: colocation['color'],
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                '$position º',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            ImgCircularWidget(
                              height: 60,
                              width: 60,
                              image: participant.user.photo,
                              borderColor: AppColors.green_500
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${participant.user.firstName} ${participant.user.lastName}",
                                    style: Theme.of(context).textTheme.titleSmall,
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
                                  PositionWidget(
                                    position: participant.user.player!.mainPosition,
                                    mainPosition: true,
                                    width: 35,
                                    height: 25,
                                    textSide: 10,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '34 Gols',
                                style: Theme.of(context).textTheme.titleSmall,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ]
                )
              ),
            ]
          );
        }),
      ),
    );
  }
}