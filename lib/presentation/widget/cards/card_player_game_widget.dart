import 'package:flutter/material.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/utils/img_utils.dart';
import 'package:futzada/core/utils/user_utils.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';

class CardPlayerGameWidget extends StatelessWidget {
  final UserModel user;
  final String? modality;
  const CardPlayerGameWidget({
    super.key,
    required this.user,
    this.modality
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircleAvatar(
                backgroundImage: ImgUtils.getUserImg(user.photo),
              ),
            ),
            Column(
              children: [
                Text(
                  UserUtils.getFullName(user),
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
                if(modality != null)...[
                  PositionWidget(
                    position: user.player!.mainPosition[modality]!,
                    mainPosition: true,
                    width: 35,
                    height: 25,
                    textSide: 10,
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}