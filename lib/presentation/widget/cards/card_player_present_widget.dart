import 'package:flutter/material.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';

class CardPlayerPresentWidget extends StatelessWidget {
  final UserModel user;
  final String modality;
  final bool present;
  const CardPlayerPresentWidget({
    super.key,
    required this.user,
    required this.modality,
    required this.present
  });

  @override
  Widget build(BuildContext context) {
    
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    backgroundImage: ImgHelper.getUserImg(user.photo),
                  ),
                ),
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserHelper.getFullName(user),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                    if(user.player != null)...[
                      PositionWidget(
                        position: user.player!.mainPosition[modality]!,
                        mainPosition: true,
                        width: 35,
                        height: 25,
                        textSide: 10,
                      ),
                    ]
                  ],
                ),
              ],
            ),
            Icon(
              present ? Icons.check_circle : AppIcones.question_circle_solid,
              color: present ? AppColors.green_300 : AppColors.yellow_500,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}