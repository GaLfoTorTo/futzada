import 'package:flutter/material.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/presentation/widget/others/players_escalation_widget.dart';

class EscalationWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String category;
  final String formation;

  const EscalationWidget({
    super.key,
    this.width = 342,
    this.height = 518,
    this.category = "Futebol",
    this.formation = '4-3-3'
  });

  @override
  State<EscalationWidget> createState() => _EscalationWidgetState();
}

class _EscalationWidgetState extends State<EscalationWidget> {
  //INICIARLIZAR SERVIÇO DE CAMPO/QUADRA
  EscalationController escalationController = EscalationController.instance;

  //FUNÇÃO PARA RENDERIZAR CAMPO
  Widget renderField(){
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.green_300,
        border: Border.all(color: AppColors.white, width: 5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark_300.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0,5), 
          ),
        ],
      ),
      child: SvgPicture.asset(
        ModalityHelper.getCategoryCourt(widget.category),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0008)
            ..rotateX(-0.7), 
          child: renderField()
        ),
        //COMPONENTE AQUI
        const PlayersEscalationWidget()
      ]
    );
  }
}