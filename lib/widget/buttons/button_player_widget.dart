import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/player_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/dialogs/player_dialog_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';
import 'package:get/get.dart';

class ButtonPlayerWidget extends StatelessWidget {
  final PlayerModel? player;
  final String ocupation;
  final bool? capitan;
  final int? index;
  final double? size;
  final Color? borderColor;
  final bool? userDefault;
  final bool? showName;

  const ButtonPlayerWidget({
    super.key,
    this.player,
    required this.ocupation,
    this.capitan = false,
    this.index,
    this.size = 55,
    this.borderColor = AppColors.white,
    this.userDefault = false,
    this.showName = false
  });

  @override
  Widget build(BuildContext context) {
    //FUNÇÃO PARA ABRIR O DIALOG DO JOGADOR
    void showDialogPlayer(PlayerModel? player) {
      //RESGATAR CONTROLLER DE ESCALAÇÃO
      var controller = EscalationController.instace;
      //ATUALIZAR INDEX DE JOGADOR SELECIONADO
      controller.selectedPlayer.value = index ?? 0;
      controller.selectedOcupation.value = ocupation;
      //VERIFICAR SE JOGADOR NÃO É NULO
      if(player != null){
        //CHAMAR DIALOG DO JOGADOR
        Get.bottomSheet(PlayerDialogWidget(player: player), isScrollControlled: true);
      }else{
        //AJUSTAR FILTRO
        controller.setFilter('positions', controller.getPositionFromEscalation(index));
        controller.update();
        //NAVEGAR PARA PAGINA DE MERCADO
        Get.toNamed('/escalation/market');
      }
    }

    //FUNÇÃO PARA DEFINIR BOTÃO DE JOGADOR
    List<Widget> setPlayerButton(PlayerModel? player){
      //VERIFICAR SE JOGADOR FOI DEFINIDO
      if(player != null){
        return [
          if(player.currentPontuation != null)...[
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
              child: Row(
                crossAxisAlignment: player.currentPontuation == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    "${player.currentPontuation}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppHelper.setColorPontuation(player.currentPontuation)['color'],
                    ),
                  ),
                  Icon(
                    AppHelper.setColorPontuation(player.currentPontuation)['icon'],
                    size: 10,
                    color: AppHelper.setColorPontuation(player.currentPontuation)['color'],
                  ),
                ],
              ),
            ),
          ],
          InkWell(
            onTap: () => showDialogPlayer(player),
            child:
              ImgCircularWidget(
                height: size!,
                width: size!,
                image: player.user.photo,
                borderColor: borderColor,
              ),
          ),
          if(showName!)...[
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.dark_500.withAlpha(70),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${player.user.firstName} ${player.user.lastName}",
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
            onTap: () => showDialogPlayer(player),
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
      height: player!= null ? size! + 50 : size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: setPlayerButton(player)
      ),
    );
  }
}