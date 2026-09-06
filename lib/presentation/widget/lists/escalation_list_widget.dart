import 'package:flutter/material.dart';
import 'package:esportly/data/services/escalation_service.dart';
import 'package:esportly/presentation/widget/cards/card_escalation_list_widget.dart';

class EscalationListWidget extends StatelessWidget {
  final String title;
  final String occupation;
  final String category;
  final String formation;
  final List<int?> players;

  const EscalationListWidget({
    super.key,
    required this.title,
    required this.occupation,
    this.category = "Futebol",
    this.formation = '4-3-3',
    this.players = const [],
  });

  @override
  Widget build(BuildContext context) {
    final escalationService = EscalationService();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        Column(
          children: players.asMap().entries.map((entry) {
            final index = entry.key;

            final String rawPosition = occupation == "starters"
                ? escalationService.getPositionEscalation(
                    index,
                    category,
                    formation,
                  )
                : escalationService.getReservePosition(
                    index,
                    category,
                  );

            final String position = escalationService.getPositionAlias(rawPosition);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CardEscalationListWidget(
                user: null,
                index: index,
                position: position,
                ocupation: occupation,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
