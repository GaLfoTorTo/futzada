import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/helpers/event_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/data/services/escalation_service.dart';
import 'package:esportly/presentation/widget/cards/card_escalation_list_widget.dart';

class EscalationListWidget extends ConsumerWidget {
  final String title;
  final String occupation;

  const EscalationListWidget({
    super.key,
    required this.title,
    required this.occupation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(escalationSessionProvider);
    final team = ref.watch(escalationTeamProvider);
    final escalationService = sl<EscalationService>();

    final escalation = occupation == "starters" ? team.starters : team.reserves;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        Column(
          children: escalation.asMap().entries.map((entry) {
            final index = entry.key;
            final i = entry.value;
            final UserModel user = EventHelper.getUserEvent(session.event!, i!)!;
            final String position = escalationService.getPositionEscalation(
              index,
              session.category,
              session.formation,
            );
            final String positionAlias =
                position.characters.getRange(0, 3).toLowerCase().toString();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CardEscalationListWidget(
                user: user,
                index: index,
                position: positionAlias,
                ocupation: occupation,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
