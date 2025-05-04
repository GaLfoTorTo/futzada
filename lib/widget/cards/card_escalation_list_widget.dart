import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/player_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_player_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class CardEscalationListWidget extends StatefulWidget {
  final PlayerModel? player;
  final String namePosition;

  const CardEscalationListWidget({
    super.key,
    required this.player,
    required this.namePosition
  });

  @override
  State<CardEscalationListWidget> createState() => _CardEscalationListWidgetState();
}

class _CardEscalationListWidgetState extends State<CardEscalationListWidget> {
  //CONTROLADOR DE POSICAO PRINCIPAL
  String? position;
  //RESGATAR JOGADOR COMO MAP
  Map<String, dynamic>? player = {};

  @override
  void initState() {
    super.initState();
    //RESGATAR JOGADOR COMO MAP
    player = widget.player != null ? widget.player!.toMap() : null;
    //ADICIONAR A FLAG DE POSIÇÃO PRINCIPAL
    loadPosition();
  }

  Future<void> loadPosition() async {
    //TENTAR CARREGAR SVG DE POSIÇÃO COMO STRING
    try {
      if(player != null){
        var string_position = await AppHelper.mainPosition(AppIcones.posicao[player!['position']]);
        position = string_position;
      }
    } catch (e) {
      position = null;
    }
    //ATUALIZAR STATE
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    Widget renderCard(){
      //VERIFICAR SE PLAYER EXISTE 
      if(player != null){
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImgCircularWidget(
                    height: 80,
                    width: 80,
                    image: player!['user']['photo'],
                    borderColor: AppColors.gray_300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${player!['user']['firstName']} ${player!['user']['lastName']}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "@${player!['user']['userName']}",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
                        ),
                        SizedBox(
                          width: (dimensions.width / 2) - 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if(position != null)...[
                                SvgPicture.string(
                                  position!,
                                  width: 25,
                                  height: 25,
                                ),
                              ]else...[
                                Container(
                                  width: 35,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    color: AppColors.gray_300,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        AppHelper.setStatusPlayer(player!['status'])['icon'],
                        color: AppHelper.setStatusPlayer(player!['status'])['color'],
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }else{
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Row(
                children: [
                  const ImgCircularWidget(
                    height: 80,
                    width: 80,
                    image: null,
                    borderColor: AppColors.gray_300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.namePosition,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.gray_500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const ButtonPlayerWidget(
              player: null,
              ocupation: 'reserves',
              size: 50,
              borderColor: AppColors.white,
            )
          ],
        );
      }
    }
    
    return Container(
      width: dimensions.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark_500.withAlpha(30),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: renderCard()
    );
  }
}