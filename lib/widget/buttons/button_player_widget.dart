import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/dialogs/player_dialog_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';
import 'package:get/get.dart';

class ButtonPlayerWidget extends StatelessWidget {
  final Map<String, dynamic>? player;
  final double? size;
  final Color? borderColor;
  final bool? userDefault;

  const ButtonPlayerWidget({
    super.key,
    this.player,
    this.size = 55,
    this.borderColor = AppColors.white,
    this.userDefault = false
  });

  @override
  Widget build(BuildContext context) {
    //FUNÇÃO PARA ABRIR O DIALOG DO JOGADOR
    void showDialogPlayer(Map<String, dynamic>? player) {
      //VERIFICAR SE JOGADOR NÃO É NULO
      if(player != null){
        //ADICIONAR BORDA NOS DADOS DO PLAYER
        player['borderColor'] = borderColor;
        //CHAMAR DIALOG DO JOGADOR
        Get.bottomSheet(PlayerDialogWidget(player: player));
      }else{
        //NAVEGAR PARA PAGINA DE MERCADO
        Get.toNamed('/escalation/market');
      }
    }

    List<Widget> setPlayerButton(player){
      //VERIFICAR SE JOGADOR FOI DEFINIDO
      if(player != null){
        return [
          if(player != null && player!['pontuation'] != null)...[
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
                crossAxisAlignment: player!['pontuation'] == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    "${player!['pontuation']}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppHelper.setColorPontuation(player!['pontuation'])['color'],
                    ),
                  ),
                  Icon(
                    AppHelper.setColorPontuation(player!['pontuation'])['icon'],
                    size: 10,
                    color: AppHelper.setColorPontuation(player!['pontuation'])['color'],
                  ),
                ],
              ),
            ),
          ],
          InkWell(
            onTap: () => showDialogPlayer(player),
            child: ImgCircularWidget(
              height: size!,
              width: size!,
              image: player != null ? player!['photo'] : null,
              borderColor: borderColor,
            )
          ),
          if(player != null && player!['firstName'] != null && player!['lastName'] != null)...[
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.dark_500.withAlpha(70),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${player!['firstName']} ${player!['lastName']}",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: AppColors.white,
                  overflow: TextOverflow.ellipsis,
                ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: setPlayerButton(player)
      ),
    );
  }
}