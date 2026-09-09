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
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Nenhuma regra adicionada",
                      style: Theme.of(context).textTheme.titleMedium
                    ),
                    Text(
                      "A pelada não tem nenhuma regra definda até o momento. acione o organizador da pelada ou os colaboradores para adicionar regras a pelada.",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Icon(
                        Icons.rule_sharp,
                        size: 150, 
                        color: AppColors.grey_300.withAlpha(50), 
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
