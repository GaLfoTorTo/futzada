import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_player_widget.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ReserveBankWidget extends StatelessWidget {
  final String category;

  const ReserveBankWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE ESCALAÇÃO
    var controller = EscalationController.instance;
    //FUNÇÃO PARA RESGATAR POSIÇÃO NO BANCO DE RESERVAS
    String getReservePosition(index){
      switch (index) {
        case 0:
          return 'gol';
        case 1:
          return 'zag';
        case 2:
          return 'lat';
        case 3:
          return 'mei';
        case 4:
          return 'ata';
        default:
          return 'ata';
      }
    }
    
    return Card(
      child: Container(
        width: dimensions.width - 20,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Obx((){
          //OBSERVAR ATUALIZAÇÕES DA ESCALAÇÃO
          final reserves = controller.reserves;
      
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...reserves.asMap().entries.map((item) {
                //RESGATAR JOGADOR NA ESCALAÇÃO
                final index = item.key;
                final player = item.value;
                //RESGATAR POSIÇÃO
                String position = getReservePosition(index);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonPlayerWidget(
                      participant: player,
                      position: position,
                      index: index,
                      occupation: 'reserves',
                      size: 60,
                    ),
                    if(player == null)...[
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          position.toUpperCase(),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.gray_300),
                        ),
                      )
                    ]
                  ],
                );
              })
            ]
          );
        }),
      ),
    );
  }
}