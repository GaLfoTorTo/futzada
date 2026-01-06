import 'package:flutter/material.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futzada/widget/badges/position_widget.dart';

class CardPlayerGameWidget extends StatelessWidget {
  final ParticipantModel participant;
  const CardPlayerGameWidget({
    super.key,
    required this.participant
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 150,
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(30),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    backgroundImage: participant.user.photo != null
                      ? CachedNetworkImageProvider(participant.user.photo!) 
                      : const AssetImage(AppImages.userDefault) as ImageProvider,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.green_300,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  "${participant.user.firstName} ${participant.user.lastName}",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
            )
          ],
        ),
      ),
    );
  }
}