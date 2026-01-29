import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/utils/user_utils.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class CardRankPositionWidget extends StatelessWidget {
  final List<UserModel> rank;
  final String type;
  final EventModel event;
  const CardRankPositionWidget({
    super.key,
    required this.rank,
    required this.type,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    //FUNÇÃO PARA FORMATAR VALOR DE RANK
    String getValueRank(dynamic value){
      switch (type) {
        case "Artilheiro":
          return "$value Gols";
        case "Assistências":
          return "$value Assistências";
        case "Média":
        case "Pontos":
          return "$value Pts.";
        case "Preço":
          return "$value Fz.";
        case "Vitórias":
          return "$value vitórias";
        default:
          return "$value";
      }
    }
    
    return Container(
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
              color: AppColors.grey_500,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
          ...rank.skip(3).take(7).map((user) {
            //RESGATAR POSIÇÃO NO RANK
            int position = rank.indexOf(user) + 1;
            Map<String, dynamic> colocation = AppHelper.setRankColocation('down');
            //RESGATAR VALOR DO PARTICIPANT
            String value = getValueRank(user.id);
            return Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: user.id == 1 ? AppColors.green_300 : AppColors.light.withAlpha(70),
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
                    image: user.photo,
                    borderColor: AppColors.green_500
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserUtils.getFullName(user),
                          style: Theme.of(context).textTheme.titleSmall,
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
                        PositionWidget(
                          position: user.player!.mainPosition[event.modality!.name]!,
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
                      value,
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          })
        ]
      )
    );
  }
}