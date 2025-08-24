import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_player_widget.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PlayersEscalationWidget extends StatelessWidget {
  final double? width;
  final double? height;
  
  const PlayersEscalationWidget({
    super.key,
    this.width = 342,
    this.height = 518,
  });

  //FUNÇÃO PARA CALCULAR A POSIÇÃO DOS JOGADORES
  List<Row> _buildPlayers() {
    //RESGATAR CONTROLLER DE ESCALAÇÃO 
    EscalationController escalationController = EscalationController.instance;
    //RESGATAR FORMAÇÃO EM FORMATO DE LISTA
    var listFormation = escalationController.escalationService.getFormationList(escalationController.selectedFormation.value);
    //LISTA DE JOGADORES
    final players = <Row>[];
    int playerIndex = -1;
    //LOOP NA FORMAÇÃO
    listFormation.toList().asMap().forEach((sectorIndex, playersInGroup) {
      players.add(
        Row(
          mainAxisAlignment: playersInGroup == 1 || playersInGroup == 2 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
          children: List.generate(playersInGroup, (key){
            //ATUALIZAR INDEX DO JOGADOR
            playerIndex = playerIndex + 1;
            //RESGATAR O NOME DA POSIÇÃO APARTIR DO SETOR DA FORMAÇÃO
            String position = escalationController.escalationService.getPositionName(
              sectorIndex, 
              escalationController.selectedCategory.value, 
              escalationController.selectedFormation.value
            );
            //RESGATAR ABREVIAÇÃO DA POSIÇÃO
            String positionAlias = position.characters.getRange(0,3).toLowerCase().toString();
            //DEFINIR BORDA DE POSIÇÃO
            var borderColor = AppHelper.setColorPosition(positionAlias);
            //VERIFICAR SE JOGADOR E O CAPITÃO
            if(escalationController.selectedPlayerCapitan.value == escalationController.starters[playerIndex]?.id){
              return Stack(
                children: [
                  ButtonPlayerWidget(
                    index: playerIndex,
                    grupoPosition: sectorIndex,
                    occupation: 'starters',
                    position: positionAlias,
                    participant: escalationController.starters[playerIndex],
                    capitan: true,
                    size: 60,
                    borderColor: borderColor,
                    showName: true,
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    child: SvgPicture.asset(
                      AppIcones.posicao['cap']!,
                      width: 15,
                      height: 15,
                    ),
                  ),
                ]
              );

            }else{
              return ButtonPlayerWidget(
                index: playerIndex,
                grupoPosition: sectorIndex,
                occupation: 'starters',
                position: positionAlias,
                participant: escalationController.starters[playerIndex],
                size: 60,
                borderColor: borderColor,
                showName: true,
              );
            }
          })
        )
      ); 
    });
    return players;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height! + 60,
      padding: const EdgeInsets.all(10),
      child: Obx((){
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildPlayers(),
        );
      }),
    );
  }
}