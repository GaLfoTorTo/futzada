import 'package:flutter/material.dart';
import 'package:futzada/widget/text/player_indicator_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class PlayerDialogWidget extends StatefulWidget {
  final Map<String, dynamic> player;

  const PlayerDialogWidget({
    super.key,
    required this.player,
  });

  @override
  State<PlayerDialogWidget> createState() => _PlayerDialogWidgetState();
}

class _PlayerDialogWidgetState extends State<PlayerDialogWidget> {
  //CONTROLADOR DE POSICAO PRINCIPAL
  String position = 'no progress';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //ADICIONAR A FLAG DE POSIÇÃO PRINCIPAL
    loadPosition();
  }

  Future<void> loadPosition() async {
    try {
      final string_position = await AppHelper.mainPosition(AppIcones.posicao[widget.player['position']]);
      setState(() {
        position = string_position;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        position = 'error';
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR JOGADOR
    var player = widget.player;
    print(player);

    return  Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(isLoading)...[
            const CircularProgressIndicator(
              color: AppColors.green_300,
              strokeWidth: 2,
            ),
          ]else...[
            SizedBox(
              child: Column(
                children: [
                  ImgCircularWidget(
                    height: 100,
                    width: 100,
                    image: player['photo'],
                    borderColor: player['borderColor'],
                  ),
                  Text(
                    "${player['firstName']} ${player['lastName']}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark_500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "@${player['userName']}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray_300,
                    ),
                  ),
                  SvgPicture.string(
                    position,
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
                children: [
                  PlayerIndicatorWidget(
                    title: "Valor de Mercado",
                    value: player['price'],
                    iconLabel: AppIcones.money_check_solid,
                    price: true,
                  ),
                  PlayerIndicatorWidget(
                    title: "Valorização",
                    value: player['valorization'],
                    iconLabel: AppIcones.sort_amount_up_solid,
                  ),
                  PlayerIndicatorWidget(
                    title: "Última Pontuação",
                    value: player['lastPontuation'],
                    iconLabel: AppIcones.calculator_solid,
                  ),
                  PlayerIndicatorWidget(
                    title: "Pontuação Média",
                    value: player['media'],
                    iconLabel: AppIcones.chart_line_solid,
                  ),
                  PlayerIndicatorWidget(
                    title: "Status",
                    value: player['status'],
                    iconLabel: AppIcones.user_checked_solid,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonTextWidget(
                  text: "Tornar Capitão",
                  icon: Icons.copyright,
                  width: (dimensions.width / 2) - 40,
                  height: 30,
                  backgroundColor: AppColors.yellow_300,
                  textColor: AppColors.dark_500,
                  action: () {print('Tornar Capitão');},
                ),
                ButtonTextWidget(
                  text: "Remover",
                  icon: AppIcones.trash_solid,
                  width: (dimensions.width / 2) - 40,
                  height: 30,
                  backgroundColor: AppColors.red_300,
                  textColor: AppColors.white,
                  action: () {print('Remover Jogador');},
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}