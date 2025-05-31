import 'package:futzada/models/participant_model.dart';
import 'package:futzada/services/escalation_service.dart';
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
    var controller = EscalationController.instace;
    var escalationService = EscalationService();

    //FUNÇÃO PARA TRATAMENTO DA FORMAÇÃO
    List<int> setPositions(){
      //VARIAVEIS PARA CONTROLE DE NUMERO DE JOGADORES NOS SETORES DO CAMPO
      var listFormation = controller.selectedFormation.split('-').map((e) => int.parse(e)).toList();
      //ADICIONAR O GOLEIRO NO INICIO DO ARRAY
      listFormation.insert(0, 1);
      //INVERTER ORDEM DO ARRAY DE POSIÇÕES
      return listFormation.reversed.toList();
    }

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
            ? controller.starters
            : controller.reserves;
          
          return Column(
            children: [
              ...escalation.entries.map((entry) {
                //RESGATAR ÍNDEX
                final index = entry.key;
                //RESGATAR JOGADOR
                final player = entry.value;
                //RESGATAR POSIÇÕES
                final positions = setPositions();
                //RESGATAR NOME DA POSIÇÃO
                final namePosition = escalationService.getPositionName(index, controller.selectedCategory, positions);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CardEscalationListWidget(
                    participant: player,
                    index: index,
                    namePosition: namePosition,
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