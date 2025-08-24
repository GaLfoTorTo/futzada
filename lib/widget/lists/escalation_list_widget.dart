import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/widget/cards/card_escalation_list_widget.dart';

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
        Obx(() {
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
                final player = entry.value;
                //RESGATAR O NOME DA POSIÇÃO APARTIR DO SETOR DA FORMAÇÃO
                String position = escalationController.escalationService.getPositionEscalation(
                  index, 
                  escalationController.selectedCategory.value, 
                  escalationController.selectedFormation.value
                );
                //RESGATAR ABREVIAÇÃO DA POSIÇÃO
                String positionAlias = position.characters.getRange(0,3).toLowerCase().toString();
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CardEscalationListWidget(
                    participant: player,
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