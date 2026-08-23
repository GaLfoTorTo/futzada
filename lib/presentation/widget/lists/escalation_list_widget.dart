import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/helpers/event_helper.dart';
import 'package:flutter/material.dart';
import 'package:esportly/presentation/controllers/escalation_controller.dart';
import 'package:esportly/presentation/widget/cards/card_escalation_list_widget.dart';

class EscalationListWidget extends StatelessWidget {
  final String title;
  final String occupation;
  
  const EscalationListWidget({
    super.key,
    required this.title,
    required this.occupation,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE ESCALAÇÃO
    EscalationController escalationController = EscalationController.instance;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ListenableBuilder(listenable: EscalationController.instance, builder: (_, __){
          //OBSERVAR MUDANÇA NA ESCALAÇÃO
          final escalation = occupation == "starters" 
            ? escalationController.starters
            : escalationController.reserves;
          
          return Column(
            children: [
              ...escalation.asMap().entries.map((entry) {
                //RESGATAR ÍNDEX
                final index = entry.key;
                //RESGATAR JOGADOR
                final i = entry.value;
                UserModel user = EventHelper.getUserEvent(escalationController.event!, i!)!;
                //RESGATAR O NOME DA POSIÇÃO APARTIR DO SETOR DA FORMAÇÃO
                String position = escalationController.escalationService.getPositionEscalation(
                  index, 
                  escalationController.category, 
                  escalationController.formation
                );
                //RESGATAR ABREVIAÇÃO DA POSIÇÃO
                String positionAlias = position.characters.getRange(0,3).toLowerCase().toString();
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CardEscalationListWidget(
                    user: user,
                    index: index,
                    position: positionAlias,
                    ocupation: occupation,
                  ),
                );
              }).toList(),
            ],
          );
        }),
      ],
    );
  }
}