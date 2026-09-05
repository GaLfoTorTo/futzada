import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/core/providers/event/event_session_provider.dart';
import 'package:esportly/presentation/widget/cards/card_rule.dart';

class EventRulesPage extends ConsumerStatefulWidget {
  const EventRulesPage({super.key});

  @override
  ConsumerState<EventRulesPage> createState() => _EventRulesPageState();
}

class _EventRulesPageState extends ConsumerState<EventRulesPage> {
  late PageController inProgressController;
  late EventModel event;

  @override
  void initState() {
    super.initState();
    event = ref.read(eventSessionProvider).event!;
    inProgressController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(event.rules != null && event.rules!.isNotEmpty)...[
              ...event.rules!.map((rule) => CardRule(rule: rule)),
            ]else...[
              Column(
                spacing: 50,
                children: [
                  Text(
                    "A pelada ainda não registrou nenhuma regra",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.grey_500
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.rule_rounded,
                    size: 200,
                    color: AppColors.grey_500.withAlpha(50),
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
