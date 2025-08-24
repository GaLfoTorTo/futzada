import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/player_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/widget/dialogs/player_dialog.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_valuation_widget.dart';

class ButtonPlayerWidget extends StatelessWidget {
  final int index;
  final String occupation;
  final String position;
  final ParticipantModel? participant;
  final bool? capitan;
  final int? grupoPosition;
  final Color borderColor;
  final double? size;
  final bool? userDefault;
  final bool? showName;

  const ButtonPlayerWidget({
    super.key,
    required this.index,
    required this.occupation,
    required this.position,
    this.participant,
    this.capitan = false,
    this.grupoPosition,
    this.borderColor = AppColors.white,
    this.size = 55,
    this.userDefault = false,
    this.showName = false
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE ESCALAÇÃO
    EscalationController escalationController = EscalationController.instance;
    
    //FUNÇÃO PARA ABRIR O DIALOG DO JOGADOR
    void selectPlayer(ParticipantModel? participant) {
      //ATUALIZAR INDEX DE JOGADOR SELECIONADO
      escalationController.selectedPlayer.value = index;
      escalationController.selectedOccupation.value = occupation;
      //VERIFICAR SE JOGADOR NÃO É NULO
      if(participant != null){
        //CHAMAR DIALOG DO JOGADOR
        Get.bottomSheet(PlayerDialog(participant: participant), isScrollControlled: true);
      }else{
        //AJUSTAR FILTRO PARA POSIÇÃO SELECIONADA
        escalationController.setFilter('positions', [position]);
        escalationController.update();
        //NAVEGAR PARA PAGINA DE MERCADO
        Get.toNamed('/escalation/market');
      }
      escalationController.update();
    }

    //FUNÇÃO PARA DEFINIR BOTÃO DE JOGADOR
    List<Widget> setPlayerButton(ParticipantModel? participant){
      //VERIFICAR SE JOGADOR FOI DEFINIDO
      if(participant != null){
        //RESGATAR JOGADOR
        PlayerModel player = participant.user.player!;

        return [
          if(player.rating!.points != null)...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_300.withAlpha(50),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0,5), 
                  ),
                ],
              ),
              child: IndicatorValuationWidget(
                points: player.rating!.points
              )
            ),
          ],
          InkWell(
            onTap: () => selectPlayer(participant),
            child:
              ImgCircularWidget(
                height: size!,
                width: size!,
                image: participant.user.photo,
                borderColor: borderColor,
              ),
          ),
          if(showName!)...[
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.dark_500.withAlpha(90),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${participant.user.firstName} ${participant.user.lastName}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 10,
                  color: AppColors.white, 
                  overflow: TextOverflow.ellipsis
                )
              ),
            ),
          ],
        ];
      }else{
        return [
          InkWell(
            onTap: () => selectPlayer(participant),
            child: 
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(userDefault! ? AppImages.userDefault : AppImages.plus) as ImageProvider,
                  fit: BoxFit.contain
                ),
                color: AppColors.green_300,
                border: Border.all(
                  color: AppColors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(size! / 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_300.withAlpha(50),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0,5), 
                  ),
                ],
              ),
            )
          ),
        ];
      }
    }

    return Container(
      height: participant!= null ? size! + 50 : size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: setPlayerButton(participant)
      ),
    );
  }
}