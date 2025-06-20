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
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                if(eventController.myEvents.isNotEmpty)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Participando',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: eventController.myEvents.map((entry) {
                      //RESGATAR ITENS 
                      EventModel item = entry;
                      return  CardEventListWidget(event: item);
                    }).toList(),
                  ),
                ],
                if(suggestions.isNotEmpty)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Sugestões',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: suggestions.map((entry) {
                      //RESGATAR ITENS 
                      EventModel sugestion = entry;
                      return  CardEventListWidget(event: sugestion);
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