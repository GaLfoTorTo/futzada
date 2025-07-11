import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/widget/buttons/button_player_widget.dart';
import 'package:futzada/widget/dialogs/player_dialog.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/controllers/escalation_controller.dart';

class CardEscalationListWidget extends StatefulWidget {
  final ParticipantModel? participant;
  final int index;
  final String namePosition;
  final String ocupation;

  const CardEscalationListWidget({
    super.key,
    required this.participant,
    required this.index,
    required this.namePosition,
    required this.ocupation
  });

  @override
  State<CardEscalationListWidget> createState() => _CardEscalationListWidgetState();
}

class _CardEscalationListWidgetState extends State<CardEscalationListWidget> {
  //CONTROLADOR DE POSICAO PRINCIPAL
  String? position;
  String? positionAlias;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadPosition() async {
    //TENTAR CARREGAR SVG DE POSIÇÃO COMO STRING
    try {
      if(widget.participant != null){
        //RESGATAR STRING DE SVG DA POSIÇÃO DO USUARIO
        var stringPosition = await AppHelper.mainPosition(AppIcones.posicao[widget.participant!.user.player!.mainPosition]);
        position = stringPosition;
        //RESGATAR SIGLA DE POSIÇÃO DO USUARIO
        positionAlias = widget.namePosition.characters.getRange(0,3).toLowerCase().toString();
      }
    } catch (e) {
      //DEFINIR STRING DE SVG DA POSIÇÃO DO USUARIO COMO NULL
      position = null;
      //DEFINIR SIGLA DE POSIÇÃO DO USUARIO COMO NULL
      positionAlias = '';
    }
    //ATUALIZAR STATE
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //CARREGAR POSIÇÃO PRINCIPAL
    loadPosition();

    return Obx(() {
      //RESGATAR CONTROLLER
      final controller = EscalationController.instance;
      //RESGATAR JOGADOR NA ESCALAÇÃO
      ParticipantModel? participant = widget.ocupation == "starters" 
          ? controller.starters[widget.index]
          : controller.reserves[widget.index];
      
      return Container(
        width: MediaQuery.of(context).size.width,
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
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            if(participant != null)...[
              InkWell(
                onTap: () => Get.bottomSheet(PlayerDialog(participant: participant), isScrollControlled: true),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImgCircularWidget(
                      height: 80,
                      width: 80,
                      image: participant.user.photo,
                      borderColor: AppHelper.setColorPosition(positionAlias),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${participant.user.firstName} ${participant.user.lastName}",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "@${participant.user.userName}",
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
                          AppHelper.setStatusPlayer(participant.status)['icon'],
                          color: AppHelper.setStatusPlayer(participant.status)['color'],
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ) 
            ]else...[
              Row(
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
                  ButtonPlayerWidget(
                    participant: null,
                    index: widget.index,
                    ocupation: widget.ocupation,
                    size: 50,
                    borderColor: AppColors.white,
                  )
                ],
              )
            ]
          ],
        ) 
      );
    });
  }
}