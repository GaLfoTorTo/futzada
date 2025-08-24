import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/widget/buttons/button_player_widget.dart';
import 'package:futzada/widget/dialogs/player_dialog.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/badges/position_widget.dart';

class CardEscalationListWidget extends StatelessWidget {
  final ParticipantModel? participant;
  final int index;
  final String ocupation;
  final String position;

  const CardEscalationListWidget({
    super.key,
    required this.participant,
    required this.index,
    required this.ocupation,
    required this.position
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //RESGATAR CONTROLLER
      EscalationController escalationController = EscalationController.instance;
      //RESGATAR JOGADOR NA ESCALAÇÃO
      ParticipantModel? participant = ocupation == "starters" 
        ? escalationController.starters[index]
        : escalationController.reserves[index];

      return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
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
          children: [
            if(participant != null)...[
              InkWell(
                onTap: () => Get.bottomSheet(PlayerDialog(participant: participant), isScrollControlled: true),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImgCircularWidget(
                      height: 80,
                      width: 80,
                      image: participant.user.photo,
                      borderColor: AppHelper.setColorPosition(position),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${participant.user.firstName} ${participant.user.lastName}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "@${participant.user.userName}",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
                          ),
                          PositionWidget(
                            position: position,
                            mainPosition: true,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          AppHelper.setStatusPlayer(participant.status)['icon'],
                          color: AppHelper.setStatusPlayer(participant.status)['color'],
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ) 
            ]else...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        const ImgCircularWidget(
                          height: 80,
                          width: 80,
                          image: null,
                          borderColor: AppColors.gray_300,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                position,
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.gray_500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ButtonPlayerWidget(
                    participant: null,
                    index: index,
                    occupation: ocupation,
                    position: position,
                    size: 50,
                  )
                ],
              )
            ]
          ],
        ) 
      );
    });
  }
}