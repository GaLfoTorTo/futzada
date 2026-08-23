import 'package:esportly/presentation/pages/event/error/erro_event_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/presentation/controllers/event_controller.dart';
import 'package:esportly/presentation/widget/cards/card_event_list_widget.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE EVENTO
    EventController eventController = EventController.instance;
    //BUSCAR SUGESTÕES DE EVENTOS
    List<EventModel> suggestions = [];//eventController.getSuggestions();
    
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
              if(eventController.events.isEmpty)...[
                const ErroEventPage()
              ]else...[
                Text(
                  'Participando',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Column(
                  spacing: 10,
                  children: eventController.events.map((event) {
                    return  CardEventListWidget(event: event);
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
                      return  CardEventListWidget(event: suggestion);
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