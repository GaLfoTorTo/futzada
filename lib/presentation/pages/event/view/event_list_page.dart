import 'package:esportly/presentation/pages/event/error/erro_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/core/providers/event/event_session_provider.dart';
import 'package:esportly/presentation/widget/cards/card_event_list_widget.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';

class EventListPage extends ConsumerWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<EventModel> events = ref.watch(eventSessionProvider.select((s) => s.events));
    final List<EventModel> suggestions = [];

    return Scaffold(
      appBar: HeaderWidget(
        title: "Minhas Peladas",
        leftAction: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(events.isEmpty)...[
                const ErroEventPage()
              ]else...[
                Text(
                  'Participando',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Column(
                  spacing: 10,
                  children: events.map((event) {
                    return CardEventListWidget(event: event);
                  }).toList(),
                ),
                if(suggestions.isNotEmpty)...[
                  Text(
                    'Sugestões',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Column(
                    spacing: 10,
                    children: suggestions.map((suggestion) {
                      return CardEventListWidget(event: suggestion);
                    }).toList(),
                  ),
                ]
              ],
            ]
          ),
        ),
      ),
    );
  }
}
