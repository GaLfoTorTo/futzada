import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/helpers/player_helper.dart';
import 'package:esportly/core/helpers/event_helper.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/widget/buttons/button_player_widget.dart';
import 'package:esportly/presentation/widget/bottomSheet/bottomsheet_player.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';

class CardEscalationListWidget extends ConsumerWidget {
  final UserModel? user;
  final int index;
  final String ocupation;
  final String position;

  const CardEscalationListWidget({
    super.key,
    required this.user,
    required this.index,
    required this.ocupation,
    required this.position,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(escalationSessionProvider);
    final team = ref.watch(escalationTeamProvider);
    final int? i = ocupation == "starters" 
      ? team.starters[index] 
      : team.reserves[index];
    final UserModel? resolvedUser = i != null 
      ? EventHelper.getUserEvent(session.event!, i) 
      : null;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            if (resolvedUser != null) ...[
              InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                  builder: (_) => BottomSheetPlayer(user: resolvedUser),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    ImgCircularWidget(
                      size: 70,
                      image: resolvedUser.photo,
                      borderColor: PlayerHelper.setColorPosition(position.toUpperCase()),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserHelper.getFullName(resolvedUser),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "@${resolvedUser.userName}",
                          style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.grey_300),
                        ),
                        PositionWidget(
                          width: 35,
                          height: 20,
                          textSide: 8,
                          position: position, 
                          mainPosition: true
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              AppHelper.setStatusPlayer(
                                UserHelper.getParticipant(
                                  resolvedUser.participants,
                                  session.event!.id!,
                                )!.status,
                              )['icon'],
                              color: AppHelper.setStatusPlayer(
                                UserHelper.getParticipant(
                                  resolvedUser.participants,
                                  session.event!.id!,
                                )!.status,
                              )['color'],
                              size: 30,
                            ),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const ImgCircularWidget(
                        size: 70,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: AppColors.grey_500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ButtonPlayerWidget(
                    user: null,
                    index: index,
                    occupation: ocupation,
                    position: position,
                    size: 50,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
