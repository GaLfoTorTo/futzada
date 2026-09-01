import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  String _positionAlias(String position) {
    final part = position.split('-').first;
    final len = part.length.clamp(0, 3);
    return part.characters.getRange(0, len).toLowerCase().toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(escalationSessionProvider);
    final team = ref.watch(escalationTeamProvider);
    final escalationService = EscalationService();

    final slots = occupation == "starters" ? team.starters : team.reserves;

    if (slots.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        Column(
          children: slots.asMap().entries.map((entry) {
            final index = entry.key;

            final String position = occupation == "starters"
                ? escalationService.getPositionEscalation(
                    index,
                    session.category,
                    session.formation,
                  )
                : escalationService.getReservePosition(index, session.category);

            final String positionAlias = _positionAlias(position);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CardEscalationListWidget(
                user: null,
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
