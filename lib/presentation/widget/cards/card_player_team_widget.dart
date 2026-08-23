import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/providers/game/game_session_provider.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';

class CardPlayerTeamWidget extends ConsumerStatefulWidget {
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
  ConsumerState<CardPlayerTeamWidget> createState() => _CardPlayerTeamWidgetState();
}

class _CardPlayerTeamWidgetState extends ConsumerState<CardPlayerTeamWidget> {
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
                    size: 70,
                    image: widget.user.photo,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserHelper.getFullName(widget.user),
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                      ),
                      Text(
                        "@${widget.user.userName}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                    AppHelper.setStatusPlayer(UserHelper.getParticipant(widget.user.participants, ref.read(gameSessionProvider).event?.id ?? 0)!.status)['icon'],
                    color: AppHelper.setStatusPlayer(UserHelper.getParticipant(widget.user.participants, ref.read(gameSessionProvider).event?.id ?? 0)!.status)['color'],
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