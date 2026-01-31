import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/helpers/player_helper.dart';
import 'package:futzada/core/helpers/event_helper.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/presentation/widget/buttons/button_player_widget.dart';
import 'package:futzada/presentation/widget/bottomSheet/bottomsheet_player.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';

class CardEscalationListWidget extends StatelessWidget {
  final UserModel? user;
  final int index;
  final String ocupation;
  final String position;

  const CardEscalationListWidget({
    super.key,
    required this.user,
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
      int? i = ocupation == "starters" 
        ? escalationController.starters[index]
        : escalationController.reserves[index];
      //RESGATAR JOGADOR REFERENCIADO NA ESCALAÇÃO
      UserModel? user = EventHelper.getUserEvent(escalationController.event!, i!);
      return Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              if(user != null)...[
                InkWell(
                  onTap: () => Get.bottomSheet(BottomSheetPlayer(user: user), isScrollControlled: true),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      ImgCircularWidget(
                        height: 70,
                        width: 70,
                        image: user.photo,
                        borderColor: PlayerHelper.setColorPosition(position),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserHelper.getFullName(user),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "@${user.userName}",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_300),
                          ),
                          PositionWidget(
                            position: position,
                            mainPosition: true,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            AppHelper.setStatusPlayer(UserHelper.getParticipant(user.participants, escalationController.event!.id!)!.status)['icon'],
                            color: AppHelper.setStatusPlayer(UserHelper.getParticipant(user.participants, escalationController.event!.id!)!.status)['color'],
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
                            height: 70,
                            width: 70,
                            image: null,
                            borderColor: AppColors.grey_300,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  position.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.grey_500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ButtonPlayerWidget(
                      user: null,
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
        ),
      );
    });
  }
}