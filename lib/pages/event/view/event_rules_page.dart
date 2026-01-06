import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/cards/card_rule.dart';

class EventRulesPage extends StatefulWidget {
  const EventRulesPage({
    super.key,
  });

  @override
  State<EventRulesPage> createState() => _EventRulesPageState();
}

class _EventRulesPageState extends State<EventRulesPage> {
  //RESGATAR CONTROLLER DO EVENTO
  EventController eventController = EventController.instance;
  //CONTROLLADOR DE DESTAQUES
  late PageController inProgressController;
  //ESTADO - EVENTO
  late EventModel event;

  @override
  void initState() {
    super.initState();
    //RESGATAR EVENT
    event = eventController.event;
    //INICIALIZAR CONTROLLER DE PARTIDAS AO VIVO
    inProgressController = PageController();
  }


  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            Text(
              "Regras",
              style: Theme.of(context).textTheme.titleMedium
            ),
            Text(
              "As regras da pelada são definidas pelos organizadores afim de manter a qualidade e o controle sobre pelada. Consulte os organizadores e colaboradores em caso duvidas.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if(event.rules != null)...[
              Column(
                spacing: 10,
                children: event.rules!.map((rule){
                  return CardRule(
                    rule: rule
                  );
                }).toList(),
              )
            ]else...[
              Column(
                spacing: 50,
                children: [
                  Text(
                    "Nenhuma Regra Registrada",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.gray_500
                    ),
                  ),
                  Icon(
                    Icons.assignment,
                    size: 200,
                    color: AppColors.gray_500.withAlpha(50),
                  )
                ],
              )
            ]
          ]
        ),
      ),
    );
  }
}