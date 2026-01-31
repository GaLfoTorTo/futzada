import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class CardRankingWidget extends StatefulWidget {
  final double width;
  final double height;
  final Map<String, dynamic> user;
  final String indicador;
  
  const CardRankingWidget({
    super.key,
    required this.width,
    required this.height,
    required this.user,
    required this.indicador,
  });

  @override
  State<CardRankingWidget> createState() => _CardRankingWidgetState();
}

class _CardRankingWidgetState extends State<CardRankingWidget> {
  //CONTROLADOR DE POSICAO PRINCIPAL
  String posicao = 'no progress';

  @override
  void initState() {
    super.initState();
    
  }

  //FUNÇÃO PARA RESGATAR COR DA MEDALHA
  Color colocacao(colocacao){
    switch (colocacao) {
      case '1':
        return AppColors.yellow_500;
      case '2':
        return AppColors.grey_500;
      case '3':
        return AppColors.brown_500;
      default:
        return AppColors.grey_300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              ImgCircularWidget(
                width: 80,
                height: 80,
                image: widget.user['image'],
                borderColor: colocacao(widget.user['colocacao']),
              ),
              Positioned(
                top: 60,
                left: 55,
                child: Container(
                  width: 20,
                  height: 20,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey_500.withOpacity(0.7),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                  child: /* SvgPicture.asset(
                    AppIcones.trash_solid,
                    width: 20,
                    height: 20,
                    color: colocacao(widget.user['colocacao']),
                  ), */
                  Icon(AppIcones.trophy_solid),
                ),
              ),
            ]
          ),
          PositionWidget(
            position: widget.user['mainPosition'],
            mainPosition: true,
            width: 35,
            height: 25,
            textSide: 10,
          ),
          Text(
            widget.user['nome'],
            style: const TextStyle(
              color: AppColors.dark_300,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ), 
          Text(
            '@${widget.user['user_name']}',
            style: const TextStyle(
              color: AppColors.grey_300,
              fontSize: 8,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            widget.indicador,
            style: const TextStyle(
              color: AppColors.dark_300,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text(
                widget.user['media'],
                style: const TextStyle(
                  color: AppColors.green_300,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if(widget.indicador == 'Média')
                const Text(
                  'Pts',
                  style: TextStyle(
                    color: AppColors.grey_300,
                    fontSize: 8,
                    fontWeight: FontWeight.normal,
                  ), 
                ), 
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}