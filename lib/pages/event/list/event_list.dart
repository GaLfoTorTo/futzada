import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/cards/card_event_list_widget.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE EVENTO
    EventController eventController = EventController.instance;
    //BUSCAR SUGESTÕES DE EVENTOS
    List<EventModel> suggestions = eventController.getSuggestions();
    
    return Scaffold(
      appBar: HeaderWidget(
        title: "Minhas Peladas",
        leftAction: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(eventController.myEvents.isNotEmpty)...[
                  Text(
                    'Participando',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Column(
                    spacing: 10,
                    children: eventController.myEvents.map((event) {
                      return  CardEventListWidget(event: event);
                    }).toList(),
                  ),
                ],
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
              ]
            ),
          ),
        ),
      ),
    ); 
  }
}