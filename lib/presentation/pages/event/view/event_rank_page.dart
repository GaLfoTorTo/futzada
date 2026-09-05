import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/core/providers/event/event_session_provider.dart';
import 'package:esportly/presentation/controllers/rank_controller.dart';
import 'package:esportly/presentation/widget/cards/card_podium_widget.dart';
import 'package:esportly/presentation/widget/cards/card_rank_position_widget.dart';

class EventRankPage extends ConsumerWidget {
  const EventRankPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RankController rankController = RankController.instance;
    final EventModel event = ref.watch(eventSessionProvider.select((s) => s.event!));

    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Rankings da Pelada",
                  style: Theme.of(context).textTheme.titleMedium
                ),
                Text(
                  "Acompanhe de perto os jogadores e técnicos que se destacam na pelada com as melhores pontuações para cada tipo de estatística.",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ListenableBuilder(listenable: rankController, builder: (_, __) {
            return CardPodiumWidget(
              rank: rankController.topRanking.take(3).toList(),
              title: rankController.type,
              event: event,
            );
          }),
          ListenableBuilder(listenable: rankController, builder: (_, __) {
            if (rankController.topRanking.isNotEmpty) {
              return CardRankPositionWidget(
                rank: rankController.topRanking.skip(3).take(7).toList(),
                type: rankController.type,
                event: event,
              );
            }
            return Container();
          }),
        ]
      ),
    );
  }
}
