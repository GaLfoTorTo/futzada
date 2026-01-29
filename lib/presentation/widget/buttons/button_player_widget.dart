import 'package:futzada/data/models/rating_model.dart';
import 'package:futzada/core/utils/user_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/presentation/widget/bottomSheet/bottomsheet_player.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_valuation_widget.dart';

class ButtonPlayerWidget extends StatelessWidget {
  final int index;
  final String occupation;
  final String position;
  final UserModel? user;
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
    this.user,
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
    void selectPlayer(UserModel? user) {
      //ATUALIZAR INDEX DE JOGADOR SELECIONADO
      escalationController.selectedPlayer.value = index;
      escalationController.selectedOccupation.value = occupation;
      //VERIFICAR SE JOGADOR NÃO É NULO
      if(user != null){
        //CHAMAR DIALOG DO JOGADOR
        Get.bottomSheet(BottomSheetPlayer(user: user), isScrollControlled: true);
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
    List<Widget> setPlayerButton(UserModel? user){
      //VERIFICAR SE JOGADOR FOI DEFINIDO
      if(user != null){
        //RESGATAR JOGADOR
        PlayerModel player = user.player!;
        //RESGATAR RATING DO EVENTO
        RatingModel rating = UserUtils.getRating(player, escalationController.event!.id!);
        //DEEFINIR COR A PARTIR DO TEMA
        final color = Get.isDarkMode ? AppColors.dark_300 : AppColors.white;

        return [
          if(rating.points != null)...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: color,
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
                points: rating.points
              )
            ),
          ],
          InkWell(
            onTap: () => selectPlayer(user),
            child:
              ImgCircularWidget(
                height: size!,
                width: size!,
                image: user.photo,
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
                UserUtils.getFullName(user),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.white, 
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ],
        ];
      }else{
        return [
          InkWell(
            onTap: () => selectPlayer(user),
            child: 
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.green_300,
                gradient: const LinearGradient(
                  colors: [AppColors.green_300, AppColors.green_500],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
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
              child: const Icon(
                Icons.add,
                color: AppColors.white,
                size: 40,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ];
      }
    }

    return Container(
      height: user!= null ? size! + 50 : size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: setPlayerButton(user)
      ),
    );
  }
}