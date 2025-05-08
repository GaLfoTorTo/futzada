import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/widget/cards/card_escalation_list_widget.dart';
import 'package:get/get.dart';

class EscalationListWidget extends StatelessWidget {
  final String title;
  final String occupationType;
  
  const EscalationListWidget({
    super.key,
    required this.title,
    required this.occupationType,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE ESCALAÇÃO
    var controller = EscalationController.instace;

    //FUNÇÃO DE NOMECLATURA DE POSIÇÕES
    String getNamePosition(int index, String type) {
      if (type == 'starters') {
        switch (index) {
          case 0: return 'Goleiro';
          case 2: case 3: return 'Zagueiro';
          case 1: case 4: return 'Lateral';
          case 5: case 6: case 7: return 'Meio-Campo';
          case 8: case 9: case 10: return 'Atacante';
          default: return 'Jogador';
        }
      } else {
        switch (index) {
          case 0: return 'Goleiro';
          case 1: return 'Zagueiro';
          case 2: return 'Lateral';
          case 3: return 'Meio-Campo';
          case 4: return 'Atacante';
          default: return 'Jogador';
        }
      }
    }

    return Obx(() {
      final escalation = occupationType == 'starters' 
          ? controller.escalation['starters']!
          : controller.escalation['reserves']!;
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ...escalation.entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            final namePosition = getNamePosition(index, occupationType);
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CardEscalationListWidget(
                player: player,
                index: index,
                namePosition: namePosition,
                ocupation: occupationType,
              ),
            );
          }).toList(),
        ],
      );
    });
  }
}