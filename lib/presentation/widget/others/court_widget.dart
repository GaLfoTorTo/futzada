import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/data/services/escalation_service.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/others/players_court_widget.dart';

class CourtWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String category;
  final int? players;

  const CourtWidget({
    super.key,
    this.width = 342,
    this.height = 518,
    this.category = "Futebol",
    this.players = 11
  });

  @override
  State<CourtWidget> createState() => _CourtWidgetState();
}

class _CourtWidgetState extends State<CourtWidget> {
  //INICIARLIZAR SERVIÇO DE CAMPO/QUADRA
  EscalationService escalationService = EscalationService();

  //FUNÇÃO PARA RENDERIZAR CAMPO
  Widget renderField(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white, width: 5),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark_300.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0,5), 
          ),
        ],
      ),
      child: SvgPicture.asset(
        escalationService.fieldType(widget.category),
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
        PlayersCourtWidget(
          playerCount: widget.players!,
          category: widget.category,
        )
      ]
    );
  }
}