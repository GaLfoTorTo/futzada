import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/utils/user_utils.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class CardPlayerTeamWidget extends StatefulWidget {
  final UserModel user;
  final String modality;
  final VoidCallback? onPressed;
  const CardPlayerTeamWidget({
    super.key,
    required this.user,
    required this.modality,
    this.onPressed,
  });

  @override
  State<CardPlayerTeamWidget> createState() => _CardPlayerTeamWidgetState();
}

class _CardPlayerTeamWidgetState extends State<CardPlayerTeamWidget> {
  GameController gameController = GameController.instance;
  //CONTROLADOR DE POSICAO PRINCIPAL
  String? position;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Card(
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Column(
          children: [
            Row(
              children: [ 
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ImgCircularWidget(
                    width: 70, 
                    height: 70,
                    image: widget.user.photo,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserUtils.getFullName(widget.user),
                        style: Theme.of(Get.context!).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                      ),
                      Text(
                        "@${widget.user.userName}",
                        style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                          color: AppColors.grey_300,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Icon(
                    AppHelper.setStatusPlayer(UserUtils.getParticipant(widget.user.participants, gameController.event.id!)!.status)['icon'],
                    color: AppHelper.setStatusPlayer(UserUtils.getParticipant(widget.user.participants, gameController.event.id!)!.status)['color'],
                    size: 20,
                  ),
                ),
                PositionWidget(
                  position: widget.user.player!.mainPosition[widget.modality]!,
                )
              ]
            ),
          ],
        ),
      )
    );
  }
}