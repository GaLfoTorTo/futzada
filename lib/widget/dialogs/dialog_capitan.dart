import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/widget/badges/position_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/controllers/escalation_controller.dart';

class DialogCapitan extends StatelessWidget {
  const DialogCapitan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR INSTÂNCIA DO CONTROLLER DE ESCALAÇÃO
    EscalationController escalationController = EscalationController.instance;

    //FUNÇÃO DE DEFINIÇÃO DO CAPITÃO
    void setCapitan(int? id) {
      escalationController.selectedPlayerCapitan.value = id ?? 0;
      Get.back();
    }
    
    return Dialog(
      child: Container(
        height: dimensions.height * 0.6,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Definir Capitão',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Defina um de seus jogadores escalados para ser o capitão da equipe. O capitão tem sua pontuação dobrada no fim da rodada.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.gray_500),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView(
                children: escalationController.starters.map((participant) {
                  int index = escalationController.starters.indexOf(participant);
                  //RESGATAR O NOME DA POSIÇÃO APARTIR DO SETOR DA FORMAÇÃO
                  String position = escalationController.escalationService.getPositionEscalation(
                    index, 
                    escalationController.selectedCategory.value, 
                    escalationController.selectedFormation.value
                  );
                  //RESGATAR ABREVIAÇÃO DA POSIÇÃO
                  String positionAlias = position.characters.getRange(0,3).toLowerCase().toString();
              
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: participant?.user.id == escalationController.selectedPlayerCapitan.value,
                              onChanged: (bool? selected) => setCapitan(participant?.user.id),
                            ),
                            ImgCircularWidget(
                              height: 50,
                              width: 50,
                              image: participant?.user.photo,
                              borderColor: AppHelper.setColorPosition(positionAlias),
                            ),
                            Container (
                              width: dimensions.width * 0.4,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${participant?.user.firstName} ${participant?.user.lastName}",
                                    style: Theme.of(context).textTheme.titleSmall,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: PositionWidget(
                            position: positionAlias
                          )
                        ),
                      ]
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}