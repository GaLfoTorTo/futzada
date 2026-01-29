import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/core/utils/event_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/presentation/widget/buttons/button_player_widget.dart';

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
    var listFormation = escalationController.escalationService.getFormationList(escalationController.formation.value);
    //LISTA DE JOGADORES
    final players = <Row>[];
    int playerIndex = -1;
    UserModel? user;
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
              escalationController.category.value, 
              escalationController.formation.value
            );
            if(escalationController.starters[playerIndex] != null){
              user = EventUtils.getUserEvent(escalationController.event!, escalationController.starters[playerIndex]!);
            }
            //RESGATAR ABREVIAÇÃO DA POSIÇÃO
            String positionAlias = position.characters.getRange(0,3).toLowerCase().toString();
            //DEFINIR BORDA DE POSIÇÃO
            var borderColor = AppHelper.setColorPosition(positionAlias);
            //VERIFICAR SE JOGADOR E O CAPITÃO
            if(escalationController.selectedPlayerCapitan.value == user?.id){
              return Stack(
                children: [
                  ButtonPlayerWidget(
                    index: playerIndex,
                    grupoPosition: sectorIndex,
                    occupation: 'starters',
                    position: positionAlias,
                    user: user,
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
                user: user,
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