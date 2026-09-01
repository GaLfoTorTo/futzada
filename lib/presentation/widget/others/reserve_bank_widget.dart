import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/event_helper.dart';
import 'package:esportly/data/services/escalation_service.dart';
import 'package:esportly/presentation/widget/buttons/button_player_widget.dart';

class ReserveBankWidget extends ConsumerWidget {
  final String category;

  const ReserveBankWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = MediaQuery.of(context).size;
    final session = ref.watch(escalationSessionProvider);
    final team = ref.watch(escalationTeamProvider);
    final escalationService = EscalationService();

    return Card(
      child: Container(
        width: dimensions.width - 20,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: team.reserves.asMap().entries.map((item) {
            final index = item.key;
            UserModel? user;
            if (team.reserves[index] != null) {
              user = EventHelper.getUserEvent(session.event!, team.starters[index]!);
            }
            final String position = escalationService.getReservePosition(index, category);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonPlayerWidget(
                  user: user,
                  position: position,
                  index: index,
                  occupation: 'reserves',
                  size: 60,
                ),
                if (user != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      position.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: AppColors.grey_300),
                    ),
                  ),
                ],
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
