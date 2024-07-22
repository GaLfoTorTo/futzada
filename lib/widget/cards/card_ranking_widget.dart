import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class CardRankingWidget extends StatefulWidget {
  final double width;
  final double height;
  final Map<String, dynamic> usuario;
  final String indicador;
  
  const CardRankingWidget({
    super.key,
    required this.width,
    required this.height,
    required this.usuario,
    required this.indicador,
  });

  @override
  State<CardRankingWidget> createState() => _CardRankingWidgetState();
}

class _CardRankingWidgetState extends State<CardRankingWidget> {
  //CONTROLADOR DE POSICAO PRINCIPAL
  String posicao = AppIcones.no_progress['fas']!;

  @override
  void initState() {
    super.initState();
    //ADICIONAR A FLAG DE POSIÇÃO PRINCIPAL
    mainPosition(AppIcones.posicao[widget.usuario['posicao']]);
  }

  //FUNÇÃO PARA RESGATAR COR DA MEDALHA
  Color colocacao(colocacao){
    switch (colocacao) {
      case '1':
        return AppColors.yellow_500;
      case '2':
        return AppColors.gray_500;
      case '3':
        return AppColors.brown_500;
      default:
        return AppColors.gray_300;
    }
  }

  Future<void> mainPosition(posicao) async {
    //CONVERTER SVG TO STRING
    String posicaoString = await AppHelper.svgToString(posicao);
    //ALTERAR COR DA ESTAMPA SELECIONADA NO EMBLEMA
    posicaoString = AppHelper.setMainPosition(posicaoString);
    //REATRIBUIR POSICAO
    setState(() {
      this.posicao = posicaoString;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(5),
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
                image: widget.usuario['image'],
                borderColor: colocacao(widget.usuario['colocacao']),
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
                        color: AppColors.gray_500.withOpacity(0.7),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    AppIcones.medalha['fas']!,
                    width: 20,
                    height: 20,
                    color: colocacao(widget.usuario['colocacao']),
                  ),
                ),
              ),
            ]
          ),
          SvgPicture.string(
            posicao,
            width: 20,
            height: 20,
          ),
          Text(
            widget.usuario['nome'],
            style: const TextStyle(
              color: AppColors.dark_300,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ), 
          Text(
            '@${widget.usuario['user_name']}',
            style: const TextStyle(
              color: AppColors.gray_300,
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
                widget.usuario['media'],
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
                    color: AppColors.gray_300,
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