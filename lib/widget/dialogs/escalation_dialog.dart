import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/others/lineup_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EscalationDialog extends StatefulWidget {
  final bool team;
  const EscalationDialog({
    super.key,
    required this.team
  });

  @override
  State<EscalationDialog> createState() => _EscalationDialogState();
}

class _EscalationDialogState extends State<EscalationDialog> {
  //RESGATAR CONTROLLER DE PARTIDAS
  GameController gameController = GameController.instance;
  //INDEX DE TIME ATIVO
  bool activeTeam = true;

  //FUNÇÃO DE ALTERAÇÃO DE EQUIPE
  void alterTeamView(){
    setState(() {
      activeTeam = !activeTeam;
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Container(
      height: dimensions.height * 0.75,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonTextWidget(
                width: dimensions.width * 0.42,
                height: 25,
                backgroundColor: activeTeam ? AppColors.green_300 : AppColors.green_100.withAlpha(100),
                text: "Time A",
                textSize: 12,
                textColor: AppColors.blue_500,
                iconSize: 20,
                action: () => alterTeamView()
              ),
              ButtonTextWidget(
                width: dimensions.width * 0.42,
                height: 25,
                backgroundColor: !activeTeam ? AppColors.green_300 : AppColors.green_100.withAlpha(100),
                text: "Time B",
                textSize: 12,
                textColor: AppColors.blue_500,
                iconSize: 20,
                action: () => alterTeamView()
              ),
            ],
          ),
          const Divider(color: AppColors.gray_300),
          LineupWidget(
            category: gameController.currentGameConfig!.category!
          )
        ],
      ),
    );
  }
}