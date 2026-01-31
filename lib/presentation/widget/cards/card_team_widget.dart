import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/manager_model.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/others/emblema_widget.dart';
import 'package:futzada/presentation/widget/text/price_indicator_widget.dart';

class CardTeamWidget extends StatelessWidget {
  final UserModel user;

  const CardTeamWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    final ManagerModel team = user.manager!;
    /* const colorPrimary = "green_300";
    const secondaryPrimary = "blue_500"; */

    return Card(
      child: Container(
        width: dimensions.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      image: DecorationImage(
                        image: ImgHelper.getEventImg(null),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          AppColors.green_300.withAlpha(220), 
                          BlendMode.srcATop,
                        )
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
                Column(
                  children: [
                    EmblemaWidget(emblem: user.manager!.emblem!),
                    Text(
                      team.team!,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: AppColors.blue_500
                      ),
                    ),
                    Text(
                      team.alias!,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.blue_500
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    ImgCircularWidget(
                      width: 40, 
                      height: 40,
                      image: user.photo,
                    ),
                    Column(
                      children: [
                        Text(
                          UserHelper.getFullName(user),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "@${user.userName}",
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.grey_300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const PriceIndicatorWidget(
                  title: "Preço da equipe:",
                  value: "105.3",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}