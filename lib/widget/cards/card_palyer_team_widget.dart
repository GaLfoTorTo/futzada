import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:get/get.dart';

class CardPalyerTeamWidget extends StatefulWidget {
  final ParticipantModel participant;
  final VoidCallback? onPressed;
  const CardPalyerTeamWidget({
    super.key,
    required this.participant,
    this.onPressed,
  });

  @override
  State<CardPalyerTeamWidget> createState() => _CardPalyerTeamWidgetState();
}

class _CardPalyerTeamWidgetState extends State<CardPalyerTeamWidget> {
  //CONTROLADOR DE POSICAO PRINCIPAL
  String? position;

  @override
  void initState() {
    super.initState();
    //ADICIONAR A FLAG DE POSIÇÃO PRINCIPAL
    loadPosition();
  }

  //FUNÇÃO PARA CARREGAR ICONE DE POSIÇÃO DO JOGADOR
  Future<void> loadPosition() async {
    //TENTAR CARREGAR SVG DE POSIÇÃO COMO STRING
    try {
      var string_position = await AppHelper.mainPosition(AppIcones.posicao[widget.participant.user.player!.mainPosition]);
      position = string_position;
    } catch (e) {
      position = null;
    }
    //ATUALIZAR STATE
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: AppColors.gray_300)
        )
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.gray_500,
          padding: const EdgeInsets.symmetric(vertical: 20),
        ),
        onPressed: widget.onPressed,
        child: Column(
          children: [
            Row(
              children: [ 
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ImgCircularWidget(
                    width: 70, 
                    height: 70,
                    image: widget.participant.user.photo,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.participant.user.firstName} ${widget.participant.user.lastName}",
                        style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Text(
                        "@${widget.participant.user.userName}",
                        style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                          color: AppColors.gray_300,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Icon(
                    AppHelper.setStatusPlayer(widget.participant.status)['icon'],
                    color: AppHelper.setStatusPlayer(widget.participant.status)['color'],
                    size: 20,
                  ),
                ),
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
              ]
            ),
          ],
        ),
      )
    );
  }
}